"""CoA batch 4: makes the Ascension auras that only 'exist' (HandleNoImmediateEffect) count where the CoA core reads them (Unit.cpp):
 aura 338 IGNORE_ARMOR_PCT          armor mitigation (attacker buff, or debuff the attacker put on the victim)
 aura 350 MOD_CRIT_CHANCE           melee / ranged crit (normal school) and spell crit (by school)
 aura 330 CRIT_CHANCE_AGAINST_TARGET crit chance of the caster who applied it, melee and spell
 aura 319 HEALING_RECEIVED_PCT      healing taken
 aura 360 HEALING_DONE_VERSUS_AURASTATE healing done to targets with an aura state
Not ported: the Ascension 'conditional combat modifier' tables and the spell class mask filter of 338.
Idempotent (marker 'CoA handlers batch4').  usage: python coa_hooks.py install"""
MARK = 'CoA handlers batch4'
U = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game\Entities\Unit\Unit.cpp'

EDITS = [
    # (anchor, replacement)  -- every anchor must occur exactly once
    ("        // Apply Player CR_ARMOR_PENETRATION rating and buffs from stances\\specializations etc.\n",
     "        // MARK: Ascension ignore-armor aura (attacker buff, or a debuff the attacker put on the victim)\n"
     "        {\n"
     "            int32 coaIgnoreArmorPct = attacker->GetTotalAuraModifier(SPELL_AURA_ASC_MOD_IGNORE_ARMOR_PCT);\n"
     "            if (attacker != victim)\n"
     "                coaIgnoreArmorPct += victim->GetTotalAuraModifier(SPELL_AURA_ASC_MOD_IGNORE_ARMOR_PCT, [attacker](AuraEffect const* aurEff) { return aurEff->GetCasterGUID() == attacker->GetGUID(); });\n"
     "            if (coaIgnoreArmorPct)\n"
     "                armor = std::floor(armor * (1.0f - std::min(coaIgnoreArmorPct, 100) / 100.0f));\n"
     "        }\n\n"
     "        // Apply Player CR_ARMOR_PENETRATION rating and buffs from stances\\specializations etc.\n"),
    ("            chance += GetTotalAuraModifier(SPELL_AURA_MOD_CRIT_PCT);\n        }\n    }\n\n    return chance;\n",
     "            chance += GetTotalAuraModifier(SPELL_AURA_MOD_CRIT_PCT);\n        }\n    }\n\n"
     "    chance += GetTotalAuraModifierByMiscMask(SPELL_AURA_ASC_MOD_CRIT_CHANCE, SPELL_SCHOOL_MASK_NORMAL);   // MARK\n\n    return chance;\n"),
    ("    chance += GetTotalAuraModifier(SPELL_AURA_MOD_ATTACKER_SPELL_AND_WEAPON_CRIT_CHANCE);\n\n    return std::max(chance, 0.0f);\n",
     "    chance += GetTotalAuraModifier(SPELL_AURA_MOD_ATTACKER_SPELL_AND_WEAPON_CRIT_CHANCE);\n\n"
     "    // MARK: crit chance against the target that applied this aura (normal school = melee / ranged)\n"
     "    chance += GetTotalAuraModifier(SPELL_AURA_ASC_MOD_CRIT_CHANCE_AGAINST_TARGET, [attacker](AuraEffect const* aurEff) -> bool\n"
     "    {\n        return aurEff->GetCasterGUID() == attacker->GetGUID() && (aurEff->GetMiscValue() & SPELL_SCHOOL_MASK_NORMAL);\n    });\n\n"
     "    return std::max(chance, 0.0f);\n"),
    ("    // percent done\n    // only players use intelligence for critical chance computations\n    if (Player* modOwner = GetSpellModOwner())\n        modOwner->ApplySpellMod(spellInfo, SpellModOp::CritChance, crit_chance);\n",
     "    // MARK: Ascension crit chance by school (melee / ranged normal school is already part of GetUnitCriticalChanceDone)\n"
     "    {\n        bool const physicalSpell = spellInfo->DmgClass == SPELL_DAMAGE_CLASS_MELEE || spellInfo->DmgClass == SPELL_DAMAGE_CLASS_RANGED;\n"
     "        crit_chance += GetTotalAuraModifier(SPELL_AURA_ASC_MOD_CRIT_CHANCE, [schoolMask, physicalSpell](AuraEffect const* aurEff) -> bool\n"
     "        {\n            uint32 const mask = uint32(aurEff->GetMiscValue());\n            return (mask & schoolMask) && !(physicalSpell && (mask & SPELL_SCHOOL_MASK_NORMAL));\n        });\n    }\n\n"
     "    // percent done\n    // only players use intelligence for critical chance computations\n    if (Player* modOwner = GetSpellModOwner())\n        modOwner->ApplySpellMod(spellInfo, SpellModOp::CritChance, crit_chance);\n"),
    ("    float crit_chance = doneChance;\n    switch (spellInfo->DmgClass)\n",
     "    float crit_chance = doneChance;\n"
     "    if (caster)   // MARK: crit chance against the target that applied this aura, by school\n"
     "        crit_chance += GetTotalAuraModifier(SPELL_AURA_ASC_MOD_CRIT_CHANCE_AGAINST_TARGET, [caster, spellInfo](AuraEffect const* aurEff) -> bool\n"
     "        {\n            return aurEff->GetCasterGUID() == caster->GetGUID() && (aurEff->GetMiscValue() & spellInfo->GetSchoolMask());\n        });\n"
     "    switch (spellInfo->DmgClass)\n"),
    ("    if (caster)\n    {\n        TakenTotalMod *= GetTotalAuraMultiplier(SPELL_AURA_MOD_HEALING_RECEIVED,",
     "    TakenTotalMod *= GetTotalAuraMultiplier(SPELL_AURA_ASC_MOD_HEALING_RECEIVED_PCT);   // MARK\n\n"
     "    if (caster)\n    {\n        TakenTotalMod *= GetTotalAuraMultiplier(SPELL_AURA_MOD_HEALING_RECEIVED,"),
    ("            AddPct(DoneTotalMod, CalculatePct(healingDonePctVsTargetHealth->GetAmount(), healthPctDiff));\n\n    return DoneTotalMod;\n",
     "            AddPct(DoneTotalMod, CalculatePct(healingDonePctVsTargetHealth->GetAmount(), healthPctDiff));\n\n"
     "    // MARK: Ascension healing done versus an aura state of the target\n"
     "    DoneTotalMod *= GetTotalAuraMultiplier(SPELL_AURA_ASC_MOD_HEALING_DONE_VERSUS_AURASTATE, [victim](AuraEffect const* aurEff) -> bool\n"
     "    {\n        return victim->HasAuraState(AuraStateType(aurEff->GetMiscValue()));\n    });\n\n    return DoneTotalMod;\n"),
]


def install():
    s = open(U, encoding='utf-8', errors='ignore', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    t = s.replace('\r\n', '\n')
    if MARK in t:
        print('already installed'); return
    for a, b in EDITS:
        assert t.count(a) == 1, ('anchor not unique / missing', a[:70], t.count(a))
        t = t.replace(a, b.replace('MARK', MARK))
    open(U, 'w', encoding='utf-8', newline='').write(t.replace('\n', nl))
    print('installed', len(EDITS), 'hooks')


if __name__ == '__main__':
    install()
