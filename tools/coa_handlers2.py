"""CoA aura handlers, batch 2: points the CoA custom aura slots (data/coa/coa_effect_alloc.json) at the Midnight handlers the CoA core uses for them
(HandleNoImmediateEffect = the aura only has to exist, other code reads it; flight speed; casting speed; shield block value), adds three composed handlers
(attack power flat, hit chance, crit chance) and makes spell power flat (CoA aura 345) count in the damage / healing bonus.
Idempotent (marker 'CoA handlers batch2').  usage: python coa_handlers2.py install"""
import json, re

G = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game'
ALLOC = r'C:\WowServer\Custom\data\coa\coa_effect_alloc.json'
MARK = 'CoA handlers batch2'
NOIMM = [111, 169, 178, 179, 195, 235, 277, 286, 312, 316, 317, 319, 330, 338, 348, 357, 360]   # CoA ids whose CoA handler is HandleNoImmediateEffect
MAP = {158: 'HandleShieldBlockValue', 208: 'HandleAuraModIncreaseFlightSpeed', 210: 'HandleAuraModIncreaseFlightSpeed', 211: 'HandleAuraModIncreaseFlightSpeed',
       216: 'HandleModCastingSpeed', 333: 'HandleCoaModHitChanceAll', 344: 'HandleCoaModAttackPowerFlat', 345: 'HandleModHealingDone', 350: 'HandleCoaModCritChance'}
for i in NOIMM: MAP[i] = 'HandleNoImmediateEffect'

CODE = '''
// CoA handlers batch2: composed from Midnight handlers exactly as the CoA core composes its Ascension auras
void AuraEffect::HandleCoaModAttackPowerFlat(AuraApplication const* aurApp, uint8 mode, bool apply) const
{
    HandleAuraModAttackPower(aurApp, mode, apply);
    HandleAuraModRangedAttackPower(aurApp, mode, apply);
}

void AuraEffect::HandleCoaModHitChanceAll(AuraApplication const* aurApp, uint8 mode, bool apply) const
{
    HandleModSpellHitChance(aurApp, mode, apply);   // Midnight has no separate melee hit-chance aura handler
}

void AuraEffect::HandleCoaModCritChance(AuraApplication const* aurApp, uint8 mode, bool /*apply*/) const
{
    if (!(mode & (AURA_EFFECT_HANDLE_CHANGE_AMOUNT_MASK | AURA_EFFECT_HANDLE_STAT)))
        return;

    Player* target = aurApp->GetTarget()->ToPlayer();
    if (!target)
        return;

    target->UpdateCritPercentage(BASE_ATTACK);
    target->UpdateCritPercentage(OFF_ATTACK);
    target->UpdateCritPercentage(RANGED_ATTACK);
}
'''


def rw(path, fn):
    s = open(path, encoding='utf-8', errors='ignore', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    open(path, 'w', encoding='utf-8', newline='').write(fn(s.replace('\r\n', '\n')).replace('\n', nl))


def install():
    ids = {int(k): v['to'] for k, v in json.load(open(ALLOC))['aura'].items() if v['custom']}

    def h(s):
        if MARK in s: return s
        d = '        // ' + MARK + '\n        void HandleCoaModAttackPowerFlat(AuraApplication const* aurApp, uint8 mode, bool apply) const;\n        void HandleCoaModHitChanceAll(AuraApplication const* aurApp, uint8 mode, bool apply) const;\n        void HandleCoaModCritChance(AuraApplication const* aurApp, uint8 mode, bool apply) const;\n'
        return s.replace('        void HandleModCastingSpeed(', d + '        void HandleModCastingSpeed(', 1)
    rw(G + r'\Spells\Auras\SpellAuraEffects.h', h)

    def c(s):
        if MARK in s: return s
        for cid, name in MAP.items():
            t = ids[cid]
            s, n = re.subn(r'&AuraEffect::HandleNULL,( +)//%d CoA ' % t, lambda m: '&AuraEffect::%s,%s//%d CoA ' % (name, ' ' * max(1, len(m.group(1)) - len(name) + len('HandleNULL')), t), s)
            assert n == 1, (cid, t, n)
        return s.rstrip('\n') + '\n' + CODE
    rw(G + r'\Spells\Auras\SpellAuraEffects.cpp', c)

    def u(s):
        if MARK in s: return s
        a = '    int32 DoneAdvertisedBenefit = GetTotalAuraModifierByMiscMask(SPELL_AURA_MOD_DAMAGE_DONE, schoolMask);\n'
        assert a in s
        s = s.replace(a, a + '    DoneAdvertisedBenefit += GetTotalAuraModifier(SPELL_AURA_ASC_MOD_SPELL_POWER_FLAT);   // ' + MARK + ': CoA spell power flat\n', 1)
        b = '    });\n\n    // Healing bonus of spirit, intellect and strength\n'
        assert b in s
        return s.replace(b, '    });\n    advertisedBenefit += GetTotalAuraModifier(SPELL_AURA_ASC_MOD_SPELL_POWER_FLAT);   // ' + MARK + ': CoA spell power flat\n\n    // Healing bonus of spirit, intellect and strength\n', 1)
    rw(G + r'\Entities\Unit\Unit.cpp', u)
    print('installed batch2:', len(MAP), 'aura slots')


if __name__ == '__main__':
    install()
