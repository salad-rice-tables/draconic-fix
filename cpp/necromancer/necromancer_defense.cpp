/*
 * CoA Necromancer defence rules (port of AscensionNecromancerEvents.cpp, class necromancer_defense, to the Midnight core):
 *  - creatures deal only 45% of their damage to a Necromancer's minions
 *  - Phylactery: lethal-ish damage (health would fall below 10%) is cut to 1 health and the owner turns into a Shade
 *  - Shade (500730) takes no damage, Pacify + Lich ward (560595) reduce damage
 * CoA spell ids are shifted by +7000000 in this core. A "Necromancer" is a player who knows Raise: Lesser Skeletal Warrior.
 */
#include "Creature.h"
#include "Log.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellAuras.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "SpellAuraEffects.h"
#include "SpellScript.h"
#include "TemporarySummon.h"
#include "Unit.h"

namespace
{
constexpr uint32 OFF = 7000000;
constexpr uint32 MARKER_SPELL = OFF + 500970;   // Raise: Lesser Skeletal Warrior, every Necromancer has it
constexpr float MinionShareOfCreatureDamage = 0.45f;

Player* NecroOwner(Unit const* unit)
{
    Player* player = unit ? unit->GetCharmerOrOwnerPlayerOrPlayerItself() : nullptr;
    return player && player->HasSpell(MARKER_SPELL) ? player : nullptr;
}

bool IsMinion(Player const* player, Unit const* unit)
{
    return unit && unit != player && unit->IsCreature() && unit->GetOwnerGUID() == player->GetGUID();
}

bool CreatureHitsMinion(Unit const* attacker, Unit const* victim)
{
    Player* player = NecroOwner(victim);
    return player && IsMinion(player, victim) && attacker && attacker->IsCreature() &&
           !attacker->GetCharmerOrOwnerPlayerOrPlayerItself();
}

class necromancer_defense : public UnitScript
{
public:
    necromancer_defense() : UnitScript("necromancer_defense") { }

    void ModifyMeleeDamage(Unit* target, Unit* attacker, uint32& damage) override
    {
        if (CreatureHitsMinion(attacker, target))
            damage = uint32(damage * MinionShareOfCreatureDamage);
    }

    void ModifySpellDamageTaken(Unit* target, Unit* attacker, int32& damage, SpellInfo const* /*spellInfo*/) override
    {
        if (damage > 0 && CreatureHitsMinion(attacker, target))
            damage = int32(damage * MinionShareOfCreatureDamage);
    }

    void ModifyPeriodicDamageAurasTick(Unit* target, Unit* attacker, uint32& damage) override
    {
        if (CreatureHitsMinion(attacker, target))
            damage = uint32(damage * MinionShareOfCreatureDamage);
    }

    void OnDamage(Unit* attacker, Unit* victim, uint32& damage) override
    {
        Player* player = NecroOwner(victim);
        if (!player || victim != player || !damage)
            return;
        if (player->HasAura(OFF + 560595) && player->HasAura(OFF + 500983))   // Pacify + ward: -10%
            damage -= CalculatePct(damage, 10);
        if (player->HasAura(OFF + 500730))                                    // Shade takes nothing
        {
            damage = 0;
            return;
        }
        // Phylactery: health would fall below 10% -> keep 1 health and become a Shade (once)
        if (attacker != player && !player->HasAura(OFF + 500729) &&
            int64(player->GetHealth()) - int64(damage) < int64(player->CountPctFromMaxHealth(10)))
        {
            Creature* phylactery = player->FindNearestCreature(OFF + 50132, 200.0f, true);
            bool mine = false;
            if (phylactery)
            {
                mine = phylactery->GetOwnerGUID() == player->GetGUID() || phylactery->GetCreatorGUID() == player->GetGUID();
                if (!mine)
                    if (TempSummon const* summon = phylactery->ToTempSummon())
                        mine = summon->GetSummonerGUID() == player->GetGUID();
            }
            if (mine && player->IsInMap(phylactery))
            {
                damage = std::min<uint32>(damage, player->GetHealth() > 1 ? uint32(player->GetHealth() - 1) : 0);
                player->CastSpell(player, OFF + 500730, true);
                player->CastSpell(player, OFF + 500729, true);
            }
        }
    }
};

// CoA OnSpellCheckCast: Command spells and Sacrifice Undead need at least one minion, Command also fails while Pacify (500983) is active.
class spell_ascension_necromancer_command_check : public SpellScript
{
    SpellCastResult CheckCast()
    {
        Player* player = NecroOwner(GetCaster());
        if (!player)
            return SPELL_CAST_OK;
        uint32 const id = GetSpellInfo()->Id - OFF;
        // ally buffs (Razorice / Mandates): never on an enemy
        if ((id == 500967 || (id >= 501960 && id <= 501966) || id == 572214 || id == 800199 || id == 572787 || id == 572790 || id == 680286))
        {
            Unit* explicitTarget = GetExplTargetUnit();
            if (explicitTarget && player->IsHostileTo(explicitTarget))
                return SPELL_FAILED_BAD_TARGETS;
            return SPELL_CAST_OK;
        }
        bool const sacrifice = id == 805027 || (id >= 807938 && id <= 807941) || id == 802121;
        bool const generalCommand = id == 504868;
        if (!sacrifice && player->HasAura(OFF + 500983))
            return SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
        if (generalCommand)
            return SPELL_CAST_OK;
        for (Unit* controlled : player->m_Controlled)
            if (controlled->IsAlive() && IsMinion(player, controlled))
                return SPELL_CAST_OK;
        return sacrifice ? SPELL_FAILED_NO_PET : SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW;
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_ascension_necromancer_command_check::CheckCast);
    }
};

// CoA aura_ascension_necromancer_lifecycle (id 500730): a Shade whose time runs out without reaching its Phylactery dies.
class aura_ascension_necromancer_shade : public AuraScript
{
    void Removed(AuraEffect const* /*effect*/, AuraEffectHandleModes /*mode*/)
    {
        Player* player = GetTarget()->ToPlayer();
        if (!player || !player->IsAlive() || GetTargetApplication()->GetRemoveMode() != AURA_REMOVE_BY_EXPIRE)
            return;
        player->RemoveAurasDueToSpell(OFF + 500729);
        Unit::Kill(player, player);
    }

    void Register() override
    {
        AfterEffectRemove += AuraEffectRemoveFn(aura_ascension_necromancer_shade::Removed, EFFECT_0, SPELL_AURA_ANY, AURA_EFFECT_HANDLE_REAL);
    }
};

// Undead: Assault (500982): the speed bonus is for the minions only; the owner just carries the stance marker aura.
class aura_ascension_necromancer_assault : public AuraScript
{
    void NoSpeedForPlayer(AuraEffect const* /*effect*/, SpellEffectValue& amount, bool& /*canBeRecalculated*/)
    {
        if (GetUnitOwner()->IsPlayer())
            amount = SpellEffectValue(0);
    }

    void Register() override
    {
        DoEffectCalcAmount += AuraEffectCalcAmountFn(aura_ascension_necromancer_assault::NoSpeedForPlayer, EFFECT_1, SPELL_AURA_ANY);
    }
};
}

void AddSC_necromancer_defense()
{
    RegisterSpellScript(aura_ascension_necromancer_assault);
    new necromancer_defense();
    RegisterSpellScript(spell_ascension_necromancer_command_check);
    RegisterSpellScript(aura_ascension_necromancer_shade);
}
