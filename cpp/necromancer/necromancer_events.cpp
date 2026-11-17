/*
 * CoA Necromancer damage events (port of AscensionNecromancerEvents.cpp, aura_ascension_necromancer_event).
 * One AuraScript is attached (spell_script_names + spell_proc, see sql/necromancer_events.sql) to the owner's Life Force aura (1400011)
 * and to the minion scaling aura (7805015). It sees every damaging hit done / taken by the Necromancer or one of its minions and runs the
 * talent procs. CoA spell ids are shifted by +7000000 here.
 * Not ported yet: procs that need CoA's Summon() (806086, 807700, 705747/707880, 525379, 525380) and the Ready-charge system (sequence values).
 */
#include "Creature.h"
#include "Player.h"
#include "Random.h"
#include "ScriptMgr.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellHistory.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "SpellScript.h"
#include "Unit.h"
#include <algorithm>
#include <set>
#include <unordered_map>
#include <unordered_set>
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

bool IsMinion(Player const* player, Unit const* unit)
{
    return unit && unit != player && unit->IsCreature() && unit->GetOwnerGUID() == player->GetGUID();
}

std::vector<Creature*> Minions(Player* player)
{
    std::vector<Creature*> result;
    for (Unit* controlled : player->m_Controlled)
        if (Creature* creature = controlled->ToCreature())
            if (creature->IsAlive() && IsMinion(player, creature))
                result.push_back(creature);
    return result;
}

// ---- CoA helpers -------------------------------------------------------------------------------------------------------------
std::unordered_set<ObjectGuid> inEvent;                         // CoA State.event (no recursion)
std::unordered_map<uint64, std::chrono::steady_clock::time_point> cooldowns;

void Cast(Unit* caster, Unit* target, uint32 spell)
{
    if (caster && target && caster->IsInWorld() && target->IsAlive())
        caster->CastSpell(target, OFF + spell, TRIGGERED_FULL_MASK);
}

void Copy(Unit* caster, Unit* target, uint32 spell, uint64 amount)
{
    if (!caster || !target || !target->IsAlive() || !amount)
        return;
    CastSpellExtraArgs args(TRIGGERED_FULL_MASK);
    args.AddSpellMod(SPELLVALUE_BASE_POINT0, int32(std::min<uint64>(amount, INT32_MAX)));
    caster->CastSpell(target, OFF + spell, args);
}

bool Chance(Player* player, uint32 talent, float multiplier = 1.0f, uint32 cooldownMs = 0)
{
    SpellInfo const* info = sSpellMgr->GetSpellInfo(OFF + talent, DIFFICULTY_NONE);
    if (!info || !player->HasAura(OFF + talent))
        return false;
    uint64 const key = (player->GetGUID().GetCounter() << 24) ^ talent;
    auto const now = std::chrono::steady_clock::now();
    if (auto it = cooldowns.find(key); it != cooldowns.end() && it->second > now)
        return false;
    float chance = std::clamp(info->ProcChance * multiplier, 0.0f, 100.0f);
    if (!roll_chance(chance))
        return false;
    if (cooldownMs)
        cooldowns[key] = now + std::chrono::milliseconds(cooldownMs);
    return true;
}

bool MinionChance(Player* player, Unit* holder, uint32 talent, float multiplier = 1.0f)
{
    SpellInfo const* info = sSpellMgr->GetSpellInfo(OFF + talent, DIFFICULTY_NONE);
    return info && holder && holder->HasAura(OFF + talent, player->GetGUID()) && roll_chance(std::clamp(info->ProcChance * multiplier, 0.0f, 100.0f));
}

void SummonAt(Player* player, uint32 spell, Unit* target)   // CoA Summon(player, spell, target, position): cast the summon spell at the target's position
{
    if (player && target && player->IsInWorld())
        player->CastSpell(target->GetPosition(), OFF + spell, TRIGGERED_FULL_MASK);
}

int32 Amount(uint32 spell, uint8 effect = 0)
{
    SpellInfo const* info = sSpellMgr->GetSpellInfo(OFF + spell, DIFFICULTY_NONE);
    return info ? info->GetEffect(SpellEffIndex(effect)).CalcValue() : 0;
}

void Plague(Player* player, Unit* target, uint8 stacks = 1)
{
    if (!target || !target->IsAlive() || !player->IsValidAttackTarget(target))
        return;
    uint32 const id = OFF + 570131;
    if (Aura* aura = target->GetAura(id, player->GetGUID()))
        aura->SetStackAmount(uint8(std::min<uint32>(aura->CalcMaxStackAmount(), uint32(aura->GetStackAmount()) + stacks)));
    else if (Aura* fresh = player->AddAura(id, target))
        fresh->SetStackAmount(stacks);
    if (player->HasAura(OFF + 574138))
        Cast(player, player, 573131);
}

void ReduceCooldown(Player* player, uint32 spell, int32 ms)
{
    if (player->HasSpell(OFF + spell))
        player->GetSpellHistory()->ModifyCooldown(OFF + spell, -std::chrono::milliseconds(std::abs(ms)));
}

// Lichfrost ranks (CoA family 29 word 2 0x08000000), CoA ids
bool Lichfrost(SpellInfo const* info)
{
    if (!info)
        return false;
    uint32 const id = info->Id - OFF;
    return id == 801722 || (id >= 501969 && id <= 501980);
}

bool Derived(SpellInfo const* info)
{
    if (!info)
        return false;
    switch (info->Id - OFF)
    {
        case 573242: case 801241: case 707575: case 561318: case 561095: case 570050: case 681463: case 707002: case 707284: case 505225:
            return true;
        default:
            return false;
    }
}

void Soulfreeze(Player* player, Unit* target, SpellInfo const* info)
{
    Aura const* dot = target->GetAura(info->Id, player->GetGUID());
    bool const frozen = target->HasAuraState(AURA_STATE_FROZEN) || player->HasAura(OFF + 801747) || (dot && false);
    if (frozen && Chance(player, 572023))
        Cast(player, target, 801724);
}

class aura_ascension_necromancer_event : public AuraScript
{
    bool Check(ProcEventInfo& event)
    {
        Player* player = NecroOwner(GetTarget());
        if (!player || inEvent.count(player->GetGUID()) || !event.GetActionTarget() || Derived(event.GetSpellInfo()))
            return false;
        if (GetTarget() != player && !IsMinion(player, GetTarget()))
            return false;
        return event.GetDamageInfo() && event.GetDamageInfo()->GetDamage();
    }

    void Proc(ProcEventInfo& event)
    {
        Player* player = NecroOwner(GetTarget());
        if (!player)
            return;
        inEvent.insert(player->GetGUID());
        Unit* actor = event.GetActor();
        Unit* target = event.GetActionTarget();
        SpellInfo const* info = event.GetSpellInfo();
        uint64 const damage = event.GetDamageInfo()->GetDamage();
        bool const critical = (event.GetHitMask() & PROC_HIT_CRITICAL) != 0;
        bool const periodic = bool(event.GetTypeMask() & (PROC_FLAG_DEAL_HARMFUL_PERIODIC | PROC_FLAG_TAKE_HARMFUL_PERIODIC)) ||
                              (info && (info->Id - OFF == 800343 || info->Id - OFF == 500237 || info->Id - OFF == 803779));
        bool const melee = bool(event.GetTypeMask() & (PROC_FLAG_DEAL_MELEE_SWING | PROC_FLAG_TAKE_MELEE_SWING));
        bool const outgoing = actor == GetTarget();
        bool const minion = outgoing && actor != player && IsMinion(player, actor);
        bool const own = outgoing && actor == player;

        if (!outgoing && target == GetTarget() && target->HasAura(OFF + 681529, player->GetGUID()) && actor &&
            bool(event.GetTypeMask() & (PROC_FLAG_TAKE_MELEE_SWING | PROC_FLAG_TAKE_RANGED_ATTACK | PROC_FLAG_TAKE_MELEE_ABILITY | PROC_FLAG_TAKE_RANGED_ABILITY)))
            Cast(player, actor, 707669);

        if ((minion || own) && target != player && player->IsValidAttackTarget(target))
        {
            if (AuraEffect const* ward = actor->GetAuraEffect(OFF + 680388, EFFECT_0, player->GetGUID()))
            {
                auto minions = Minions(player);
                uint64 const amount = damage * std::max<int32>(0, int32(ward->GetAmount())) / (100 * (minions.size() + 1));
                Copy(player, player, 681463, amount);
                for (Creature* unit : minions)
                    Copy(player, unit, 681463, amount);
            }
            if (minion && player->HealthBelowPct(50) && actor->HasAura(OFF + 560607, player->GetGUID()))
                Copy(player, player, 561095, damage * std::max(0, Amount(560607, 1)) / 100);
            if (minion && actor->GetEntry() != OFF + 50320 && actor->HasAura(OFF + 800027, player->GetGUID()))
                Copy(actor, target, 570050, damage * std::max(0, Amount(800027)) / 100);
            if (minion && melee && actor->HasAura(OFF + 805290, player->GetGUID()))
                Cast(actor, player, 707000);
        }

        if (own)
        {
            if (info && (info->Id - OFF == 800343 || Lichfrost(info)) && player->HasAura(OFF + 92121))
                Plague(player, target, Lichfrost(info) ? 2 : 1);
            if (info && info->Id - OFF == 800343)
            {
                if (player->HasAura(OFF + 92123))
                    Cast(player, target, 803530);
                if (player->HasAura(OFF + 500165))
                    Cast(player, player, 806588);
                if (player->HasAura(OFF + 704723))
                    if (Aura* stacks = player->GetAura(OFF + 707133))
                        stacks->ModStackAmount(-1);
            }
            bool const periodicParasites = periodic && Chance(player, 561319);
            if (periodicParasites || Chance(player, 560730))
                Cast(player, target, 560729);
            if (periodic)
            {
                if (Chance(player, 300235))
                {
                    Cast(player, player, 301334);
                    for (Creature* unit : Minions(player))
                        Cast(player, unit, 301334);
                }
                if (player->HasAura(OFF + 573223))
                    Copy(player, target, 573242, damage * 20 / 100);
                if (critical && player->HasAura(OFF + 705752))
                    Cast(player, player, 706424);
                if (Chance(player, 806086))
                    SummonAt(player, 806087, target);
                if (Chance(player, 807700))
                    SummonAt(player, 302586, target);
                if (info && info->Id - OFF == 500968 && (Chance(player, 705747) || Chance(player, 707880)))
                    SummonAt(player, 525379, target);
            }
            else if (critical && player->HasAura(OFF + 705752))
                Cast(player, player, 705753);
            if (critical && Chance(player, 806321))
                Plague(player, target);
            if (info && (info->SchoolMask & SPELL_SCHOOL_MASK_FROST))
            {
                if (Chance(player, 531135))
                    Cast(player, target, 706732);
                Soulfreeze(player, target, info);
                if (critical)
                {
                    if (player->HasAura(OFF + 707562))
                        Cast(player, player, 712434);
                    if (player->HasAura(OFF + 707588))
                        Cast(player, player, 707886);
                }
            }
            if (info && (info->SchoolMask & SPELL_SCHOOL_MASK_SHADOW) && player->HasAura(OFF + 706948))
                Cast(player, target, 706949);
            if (info && (info->SchoolMask & SPELL_SCHOOL_MASK_MAGIC) && Chance(player, 705750))
                Cast(player, player, 705751);
            if (info && info->Id - OFF == 707592 && player->HasAura(OFF + 705745))
                if (uint64 splash = damage * std::max(0, Amount(705745)) / 100)
                    Copy(player, target, 707575, splash);
        }

        if (minion)
        {
            uint8 cost = 1;
            if (Chance(player, 531128, cost))
                Cast(player, player, 531129);
            if (actor->HasAura(OFF + 560798, player->GetGUID()))
                ReduceCooldown(player, 801938, std::abs(Amount(806322)));
            if (actor->GetEntry() == OFF + 50073 && Chance(player, 503740))
                Cast(player, actor, 707014);
            if (actor->GetEntry() == OFF + 50385 && (!info || info->Id - OFF != 504022))
                Cast(actor, actor, 504022);
            if (melee && actor->GetEntry() == OFF + 50078)
                if (SpellInfo const* rogue = sSpellMgr->GetSpellInfo(OFF + 805023, DIFFICULTY_NONE))
                    if (roll_chance(int32(rogue->ProcChance)))
                        Cast(actor, target, 805024);
            if (melee && actor->GetEntry() == OFF + 503200 && actor->HasAura(OFF + 531133))
                Cast(actor, target, 531132);
            if (critical && info && (info->SchoolMask & SPELL_SCHOOL_MASK_FROST) && player->HasAura(OFF + 707562))
                Cast(player, player, 712434);
            if (critical && Chance(player, 537208, 1.0f))
                ReduceCooldown(player, 805029, std::abs(Amount(680553)));
            if (critical && melee && MinionChance(player, actor, 638403))
                Copy(actor, target, 801241, damage * std::max(0, Amount(638403, 1)) / 100);
            if (critical && (actor->GetEntry() == OFF + 50068 || actor->GetEntry() == OFF + 50115) && player->HasAura(OFF + 707283))
                Cast(actor, target, 707284);
            if (Chance(player, player->HasAura(OFF + 707882) ? 707882 : 707001))
                Cast(actor, target, 707002);
            if (MinionChance(player, actor, 802986))
            {
                Cast(actor, actor, 807653);
                Cast(actor, actor, 807765);
                Cast(actor, actor, 504022);
            }
            if (target->HasAura(OFF + 560729, player->GetGUID()))
                Copy(actor, target, 561318, damage * std::max(0, Amount(561319)) / 100);
            if (Aura* diabolical = target->GetAura(OFF + 707133, player->GetGUID()))
            {
                Copy(actor, target, 570050, damage * std::max(0, Amount(707133)) / 100);
                diabolical->ModStackAmount(-1);
            }
        }
        inEvent.erase(player->GetGUID());
    }

    void Register() override
    {
        DoCheckProc += AuraCheckProcFn(aura_ascension_necromancer_event::Check);
        OnProc += AuraProcFn(aura_ascension_necromancer_event::Proc);
    }
};
}

void AddSC_necromancer_events()
{
    RegisterSpellScript(aura_ascension_necromancer_event);
}
