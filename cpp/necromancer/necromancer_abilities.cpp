/*
 * CoA Necromancer abilities (port of AscensionNecromancerAbilities.cpp: Virulency / Infest, Expunge, and the disease Spread helper).
 * CoA spell ids are shifted by +7000000. Bound through spell_script_names, see sql/necromancer_events.sql.
 *  - Virulency (801938): refreshes the caster's diseases on the target and remembers them (aura Infestation 803782, spell Infest 803781 learnt)
 *  - Infest (803781) / Virulency while Infestation is up: copies the remembered diseases (stacks, duration, amounts, tick timers) onto the target
 *  - Expunge (500443): with diseases on the target casts 573233, extends Flesh to Worms (talent 300236) and spreads at < 20% health (704598)
 */
#include "CellImpl.h"
#include "Creature.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "SpellScript.h"
#include <array>
#include <unordered_map>
#include <vector>

namespace
{
constexpr uint32 OFF = 7000000;
constexpr uint32 MARKER_SPELL = OFF + 500970;

Player* NecroOwner(Unit const* unit)
{
    Player* player = unit ? unit->GetCharmerOrOwnerPlayerOrPlayerItself() : nullptr;
    return player && player->HasSpell(MARKER_SPELL) ? player : nullptr;
}

struct DiseaseSnapshot
{
    uint32 spell;
    uint8 stacks;
    int32 duration;
    int32 maximum;
    std::array<int32, 3> amounts;
    std::array<int32, 3> timers;
};
std::unordered_map<ObjectGuid, std::vector<DiseaseSnapshot>> saved;

bool Disease(SpellInfo const* info)
{
    if (!info)
        return false;
    uint32 const id = info->Id - OFF;
    return info->Dispel == DISPEL_DISEASE || id == 570131 || id == 802132 || id == 500338 || id == 500968;
}

bool OwnDisease(Aura const* aura, Player const* player)
{
    return aura->GetCasterGUID() == player->GetGUID() && aura->GetId() >= OFF && Disease(aura->GetSpellInfo());
}

uint32 Diseases(Player* player, Unit* target)
{
    uint32 count = 0;
    if (target)
        for (auto const& [key, application] : target->GetAppliedAuras())
            if (OwnDisease(application->GetBase(), player))
                ++count;
    return count;
}

void CopyAura(Player* player, Unit* target, Aura const* from)
{
    Aura* copy = player->AddAura(from->GetId(), target);
    if (!copy)
        return;
    copy->SetStackAmount(from->GetStackAmount());
    copy->SetMaxDuration(from->GetMaxDuration());
    copy->SetDuration(from->GetDuration());
    for (uint8 i = 0; i < MAX_SPELL_EFFECTS; ++i)
        if (AuraEffect* effect = copy->GetEffect(i))
            if (AuraEffect const* original = from->GetEffect(i))
            {
                effect->ChangeAmount(original->GetAmount());
                effect->SetPeriodicTimer(original->GetPeriodicTimer());
            }
}

void Spread(Player* player, Unit* source, uint32 limit)
{
    std::vector<uint32> ids;
    for (auto const& [key, application] : source->GetAppliedAuras())
        if (OwnDisease(application->GetBase(), player))
            ids.push_back(application->GetBase()->GetId());
    std::list<Unit*> units;
    Trinity::AnyUnitInObjectRangeCheck check(source, 10.0f);
    Trinity::UnitListSearcher<Trinity::AnyUnitInObjectRangeCheck> search(source, units, check);
    Cell::VisitAllObjects(source, search, 10.0f);
    uint32 count = 0;
    for (Unit* target : units)
    {
        if (target == source || !target->IsAlive() || !player->IsValidAttackTarget(target) || !source->IsWithinLOSInMap(target))
            continue;
        for (uint32 id : ids)
            if (Aura* original = source->GetAura(id, player->GetGUID()))
                CopyAura(player, target, original);
        if (limit && ++count >= limit)
            break;
    }
}


// CoA CorpseExplosion: every eligible corpse within 15 yd of the caster explodes (and is consumed), hurting enemies within 10 yd of it
void CorpseExplosion(Player* player, int32 amount)
{
    std::list<Unit*> dead;
    Trinity::AnyDeadUnitObjectInRangeCheck deadCheck(player, 15.0f);
    Trinity::UnitListSearcher<Trinity::AnyDeadUnitObjectInRangeCheck> deadSearch(player, dead, deadCheck);
    Cell::VisitAllObjects(player, deadSearch, 15.0f);
    for (Unit* unit : dead)
    {
        Creature* corpse = unit->ToCreature();
        if (!corpse || corpse->IsAlive() || corpse->GetOwnerGUID() == player->GetGUID() || corpse->GetCreatureType() == CREATURE_TYPE_MECHANICAL ||
            corpse->GetCreatureType() == CREATURE_TYPE_ELEMENTAL || !player->IsWithinLOSInMap(corpse))
            continue;
        std::list<Unit*> near;
        Trinity::AnyUnitInObjectRangeCheck check(corpse, 10.0f);
        Trinity::UnitListSearcher<Trinity::AnyUnitInObjectRangeCheck> search(corpse, near, check);
        Cell::VisitAllObjects(corpse, search, 10.0f);
        for (Unit* target : near)
            if (target->IsAlive() && player->IsValidAttackTarget(target))
            {
                CastSpellExtraArgs args(TRIGGERED_FULL_MASK);
                args.AddSpellMod(SPELLVALUE_BASE_POINT0, std::max(1, amount));
                player->CastSpell(target, OFF + 533240, args);
            }
        corpse->RemoveCorpse();   // consumed: another cast cannot reuse it
    }
}

class spell_ascension_necromancer_ability : public SpellScript
{
    void AfterCastHandler()
    {
        Player* player = NecroOwner(GetCaster());
        Unit* target = GetExplTargetUnit();
        if (!player || player != GetCaster())
            return;
        uint32 const id = GetSpellInfo()->Id - OFF;

        if (id == 801938 || id == 803781)   // Virulency / Infest
        {
            if (!target || !target->IsAlive())
                return;
            auto& store = saved[player->GetGUID()];
            if (player->HasAura(OFF + 803782) && !store.empty())
            {
                for (DiseaseSnapshot const& snap : store)
                    if (Aura* copy = player->AddAura(snap.spell, target))
                    {
                        copy->SetStackAmount(snap.stacks);
                        copy->SetMaxDuration(snap.maximum);
                        copy->SetDuration(snap.duration);
                        for (uint8 i = 0; i < MAX_SPELL_EFFECTS; ++i)
                            if (AuraEffect* effect = copy->GetEffect(i))
                            {
                                effect->ChangeAmount(snap.amounts[i]);
                                effect->SetPeriodicTimer(snap.timers[i]);
                            }
                    }
                if (Aura* infestation = player->GetAura(OFF + 803782); infestation && infestation->GetCharges() > 1)
                {
                    infestation->SetCharges(infestation->GetCharges() - 1);
                    return;
                }
                store.clear();
                player->RemoveAurasDueToSpell(OFF + 803782);
                player->RemoveOverrideSpell(OFF + 801938, OFF + 803781);
                return;
            }
            store.clear();
            for (auto const& [key, application] : target->GetAppliedAuras())
            {
                Aura* aura = application->GetBase();
                if (!OwnDisease(aura, player))
                    continue;
                aura->RefreshDuration();
                DiseaseSnapshot snap = { aura->GetId(), aura->GetStackAmount(), aura->GetDuration(), aura->GetMaxDuration(), {}, {} };
                for (uint8 i = 0; i < MAX_SPELL_EFFECTS; ++i)
                    if (AuraEffect const* effect = aura->GetEffect(i))
                    {
                        snap.amounts[i] = effect->GetAmount();
                        snap.timers[i] = effect->GetPeriodicTimer();
                    }
                store.push_back(snap);
            }
            if (!store.empty())
            {
                player->CastSpell(player, OFF + 803782, TRIGGERED_FULL_MASK);
                if (!player->HasSpell(OFF + 803781))
                    player->LearnSpell(OFF + 803781, true);
                player->AddOverrideSpell(OFF + 801938, OFF + 803781);
            }
        }
        else if (id >= 533236 && id <= 533239)   // Corpse Explosion (rank 1..4)
            CorpseExplosion(player, GetSpellInfo()->GetEffect(EFFECT_0).CalcValue(player));
        else if (id == 500443 && target && Diseases(player, target))   // Expunge
        {
            player->CastSpell(target, OFF + 573233, TRIGGERED_FULL_MASK);
            if (player->HasAura(OFF + 300236))
            {
                int32 const extend = std::abs(sSpellMgr->GetSpellInfo(OFF + 300236, DIFFICULTY_NONE)->GetEffect(EFFECT_0).CalcValue()) * 1000;
                for (auto const& [key, application] : target->GetAppliedAuras())
                    if (Aura* aura = application->GetBase(); aura->GetCasterGUID() == player->GetGUID() && aura->GetId() - OFF == 500338 && aura->GetDuration() > 0)
                        aura->SetDuration(aura->GetDuration() + extend);
            }
            if (target->HealthBelowPct(20) && player->HasAura(OFF + 704598))
                Spread(player, target, 3);
        }
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_ascension_necromancer_ability::AfterCastHandler);
    }
};
}

void AddSC_necromancer_abilities()
{
    RegisterSpellScript(spell_ascension_necromancer_ability);
}
