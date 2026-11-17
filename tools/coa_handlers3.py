import os
"""CoA handlers, batch 3.
 * CoA effect 190 APPLY_AURA_TO_SUMMONS = Midnight SPELL_EFFECT_APPLY_AREA_AURA_SUMMONS (202): hotfix rows and the alloc table are pointed there (no C++ needed)
 * CoA effect 113 RESURRECT_NEW (flat health, MiscValue mana): new Spell::EffectCoaResurrectNew
 * CoA aura 354 PROC_PERCENT_EVENT: the CoA core only implements it for 8 spells (percent of the damage dealt / taken is cast as the trigger spell);
   ported the same (spell ids + 7000000). The ~150 other spells with this aura are driven by per-spell C++ scripts of the CoA class modules (not generic).
Idempotent (marker 'CoA handlers batch3').  usage: python coa_handlers3.py install"""
import json, re
import pymysql

G = r'C:\WowServer\Source\Draconic-RoleplayCore\src\server\game\Spells'
ALLOC = r'C:\WowServer\Custom\data\coa\coa_effect_alloc.json'
MARK = 'CoA handlers batch3'

RES = '''
// ''' + MARK + ''': CoA RESURRECT_NEW (3.3.5 effect 113): health = effect value (flat), mana = MiscValue
void Spell::EffectCoaResurrectNew()
{
    if (effectHandleMode != SPELL_EFFECT_HANDLE_HIT_TARGET)
        return;

    if (!m_corpseTarget && !unitTarget)
        return;

    Player* player = nullptr;
    if (m_corpseTarget)
        player = ObjectAccessor::FindPlayer(m_corpseTarget->GetOwnerGUID());
    else if (unitTarget)
        player = unitTarget->ToPlayer();

    if (!player || player->IsAlive() || !player->IsInWorld() || player->IsResurrectRequested())
        return;

    uint32 const health = uint32(std::max<int32>(0, int32(effectValue)));
    uint32 const mana = uint32(std::max<int32>(0, effectInfo->MiscValue));

    ExecuteLogEffectResurrect(effectInfo->Effect, player);

    player->SetResurrectRequestData(m_caster, health, mana, 0);
    SendResurrectRequest(player);
}
'''

PROC = '''
// ''' + MARK + ''': CoA PROC_PERCENT_EVENT, implemented in the CoA core only for these eight spells (CoA id + 7000000)
namespace
{
bool CoaPercentEventSpell(uint32 id)
{
    switch (id - 7000000)
    {
        case 277785: case 280375: case 277082: case 280220: case 280225: case 280365: case 281050: case 289261:
            return true;
        default:
            return false;
    }
}
}

bool AuraEffect::CoaCheckPercentEventProc(AuraApplication* aurApp, ProcEventInfo& eventInfo) const
{
    uint32 const id = GetId();
    if (!CoaPercentEventSpell(id))
        return true;

    uint32 const coaId = id - 7000000;
    Unit* owner = aurApp->GetTarget();
    Unit* actor = eventInfo.GetActor();
    Unit* target = eventInfo.GetActionTarget();
    DamageInfo const* damage = eventInfo.GetDamageInfo();
    bool const incoming = coaId == 280225 || coaId == 281050;
    if (!owner || !owner->IsPlayer() || !target || !damage || !damage->GetDamage() || GetAmount() <= 0 || (incoming ? target != owner : actor != owner))
        return false;
    if (coaId == 280225)
        return true;
    if (coaId == 281050)
        return actor && actor != owner && owner->isInFront(actor) && (eventInfo.GetTypeMask() & (PROC_FLAG_TAKE_MELEE_SWING | PROC_FLAG_TAKE_MELEE_ABILITY));
    if (coaId == 280365)
        return target != owner;
    if (coaId == 289261)
        return target != owner && (damage->GetSchoolMask() & SPELL_SCHOOL_MASK_NORMAL);
    if (coaId == 280375)
        return (eventInfo.GetTypeMask() & PROC_FLAG_DEAL_MELEE_SWING) != 0;
    if (coaId == 280220)
        return (eventInfo.GetTypeMask() & PROC_FLAG_DEAL_HARMFUL_PERIODIC) != 0;
    // 277082 (Mangle (Bear)) and 277785 (off-hand hunter strikes) check the spell by family / name in the CoA core: not ported, they proc on any damage here
    return true;
}

void AuraEffect::HandleCoaPercentEventProc(AuraApplication* aurApp, ProcEventInfo& eventInfo)
{
    uint32 const id = GetId();
    if (!CoaPercentEventSpell(id))
        return;

    uint32 const coaId = id - 7000000;
    Unit* owner = aurApp->GetTarget();
    Unit* target = (coaId == 280225 || coaId == 280365 || coaId == 289261) ? owner : (coaId == 281050 ? eventInfo.GetActor() : eventInfo.GetActionTarget());
    DamageInfo const* damage = eventInfo.GetDamageInfo();
    uint32 const trigger = GetSpellEffectInfo().TriggerSpell;
    if (!owner || !target || !damage || !damage->GetDamage() || GetAmount() <= 0 || !sSpellMgr->GetSpellInfo(trigger, GetBase()->GetCastDifficulty()))
        return;

    int32 const amount = int32(std::min<uint64>(std::numeric_limits<int32>::max(), uint64(damage->GetDamage()) * uint32(GetAmount()) / 100));
    if (!amount)
        return;

    CastSpellExtraArgs args(this);
    args.SetTriggerFlags(TRIGGERED_FULL_MASK);
    args.AddSpellMod(SPELLVALUE_BASE_POINT0, amount);
    owner->CastSpell(target, trigger, args);
}
'''


def rw(path, fn):
    s = open(path, encoding='utf-8', errors='ignore', newline='').read()
    nl = '\r\n' if '\r\n' in s else '\n'
    open(path, 'w', encoding='utf-8', newline='').write(fn(s.replace('\r\n', '\n')).replace('\n', nl))


def install():
    a = json.load(open(ALLOC)); ids = {int(k): v['to'] for k, v in a['aura'].items() if v['custom']}
    eff = {int(k): v['to'] for k, v in a['effect'].items() if v['custom']}
    old190 = eff[190]
    # 1. effect 190 -> Midnight APPLY_AREA_AURA_SUMMONS (202) in the data
    c = pymysql.connect(host='127.0.0.1', user='root', password=os.environ.get('DB_PASSWORD', ''), database='hotfixes', autocommit=True); q = c.cursor()
    q.execute("update spell_effect set Effect=202 where Effect=%s and SpellID between 7000001 and 7999999", (old190,)); print('effect 190 ->', 202, 'rows', q.rowcount)
    a['effect']['190'] = {'to': 202, 'name': a['effect']['190']['name'], 'custom': False}; json.dump(a, open(ALLOC, 'w'), indent=1)

    def h(s):
        if MARK in s: return s
        s = s.replace('        void EffectNULL();\n', '        void EffectNULL();\n        // ' + MARK + '\n        void EffectCoaResurrectNew();\n', 1)
        return s
    rw(G + r'\Spell.h', h)

    def e(s):
        if MARK in s: return s
        t = eff[113]
        s, n = re.subn(r'&Spell::EffectNULL,( +)//%d CoA ' % t, lambda m: '&Spell::EffectCoaResurrectNew,%s//%d CoA ' % (' ' * max(1, len(m.group(1)) - len('EffectCoaResurrectNew') + len('EffectNULL')), t), s)
        assert n == 1
        return s.rstrip('\n') + '\n' + RES
    rw(G + r'\SpellEffects.cpp', e)

    def ah(s):
        if MARK in s: return s
        d = '        // ' + MARK + '\n        bool CoaCheckPercentEventProc(AuraApplication* aurApp, ProcEventInfo& eventInfo) const;\n        void HandleCoaPercentEventProc(AuraApplication* aurApp, ProcEventInfo& eventInfo);\n'
        return s.replace('        void HandleCoaModAttackPowerFlat(', d + '        void HandleCoaModAttackPowerFlat(', 1)
    rw(G + r'\Auras\SpellAuraEffects.h', ah)

    def ac(s):
        if MARK in s: return s
        # CheckEffectProc: new case before the CC auras case
        anchor = '    switch (GetAuraType())\n    {\n        case SPELL_AURA_MOD_CONFUSE:\n        case SPELL_AURA_MOD_FEAR:\n        case SPELL_AURA_MOD_STUN:\n        case SPELL_AURA_MOD_ROOT:\n        case SPELL_AURA_TRANSFORM:\n        {\n            DamageInfo* damageInfo'
        assert anchor in s
        s = s.replace(anchor, anchor.replace('    {\n        case SPELL_AURA_MOD_CONFUSE:', '    {\n        case SPELL_AURA_ASC_PROC_PERCENT_EVENT:   // ' + MARK + '\n            if (!CoaCheckPercentEventProc(aurApp, eventInfo))\n                return false;\n            break;\n        case SPELL_AURA_MOD_CONFUSE:', 1), 1)
        b = '        case SPELL_AURA_PROC_TRIGGER_DAMAGE:\n            HandleProcTriggerDamageAuraProc(aurApp, eventInfo);\n            break;\n'
        assert b in s
        s = s.replace(b, '        case SPELL_AURA_ASC_PROC_PERCENT_EVENT:   // ' + MARK + '\n            HandleCoaPercentEventProc(aurApp, eventInfo);\n            break;\n' + b, 1)
        return s.rstrip('\n') + '\n' + PROC
    rw(G + r'\Auras\SpellAuraEffects.cpp', ac)
    print('installed batch3')


if __name__ == '__main__':
    install()
