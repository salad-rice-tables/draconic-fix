-- =====================================================================
-- Battle barks for hostile groups: when a creature of a group is attacked it shouts a line that fits who it is, and sometimes a last word
-- when it dies. Groups are matched by name; the lines are written to lore (Northwatch is an Alliance expeditionary force, the Burning Blade a
-- demon-worshipping Horde cult, Razormane quilboar, Venture Co. goblins...). A creature barks at most once per 20 seconds.
-- =====================================================================
if IS_WORLD_STATE then return end

local PACKS = {
    {pattern = "Northwatch", aggro = {
        "For the Alliance! Northwatch will not fall!", "Orcs! Hold the line!", "You will not take this ground, savage!",
        "Stand fast, men! Fire at will!", "Northwatch! To arms!", "The Horde comes! Sound the alarm!", "Reload! Quickly!"},
     death = {"Tell Lord Hargrove... the Horde... is coming...", "For... Stormwind...", "Keep... the line..."}},
    {pattern = "Burning Blade", aggro = {
        "Feel the Legion's fire!", "Your blood will feed the flames!", "The Blade will burn you all!", "Ner'zhul's shadow guides us!", "Die, for the master of flame!"},
     death = {"The fire... never dies...", "I serve... until... the end..."}},
    {pattern = "Razormane", aggro = {
        "Quil! Quil! Kill da outsider!", "Dis be Razormane land!", "Feed da Razorfen spirits!", "Crush dem! Crush dem all!"},
     death = {"Da spirits... forgive...", "Razormane... never die..."}},
    {pattern = "Venture Co", aggro = {
        "Trespassers on company property! Get them!", "No one touches the Venture Co. gold!", "Security! Security!", "Time is money, and you are wasting mine!"},
     death = {"This... was not in the contract...", "My pension..."}},
    {pattern = "Defias", aggro = {
        "The Brotherhood will have your purse!", "For Edwin! For the Defias!", "Stand and deliver!", "Cut him down, lads!", "Stormwind owes us!"},
     death = {"The Brotherhood... lives on...", "Cutting... me down... changes nothing..."}},
    {pattern = "Bloodsail|Pirate|Corsair|Buccaneer", aggro = {
        "Arr! Hand over yer gold!", "Yarr! Fresh meat for the sharks!", "Man the cannons, ye scurvy dogs!", "Walk the plank!", "Yo ho! Blood for the Sail!"},
     death = {"Davy Jones... awaits...", "Me ship... me gold..."}},
    {pattern = "Kolkar|Centaur", aggro = {
        "The Barrens belong to the Kolkar!", "Khan Hratha will have your head!", "Trample them!", "Run, little ones!"}, death = {"The khans... will avenge...", "Fate... turns..."}},
    {pattern = "Khansguard", aggro = {
        "The Khansguard rides! Trample the intruders!", "No one enters our camp alive!", "For the Khan! Charge!", "Your lands will burn beneath our hooves!", "The Barrens are ours!"},
     death = {"The Khan... will... ride on...", "Our hooves... will return...", "The herd... avenges..."}},
    {pattern = "Venomtail|Scorpid", aggro = {}, death = {}},
    {pattern = "Kobold", aggro = {"You no take candle!", "Me smash you!", "Get yer own candle!", "Yip yip! Intruder!"}, death = {"Candle... mine...", "Ow..."}},
    {pattern = "Gnoll|Mosshide|Redpine|Riverpaw|Brambleblade", aggro = {"Grrr! Meat!", "Yip! Yip! Kill it!", "Defend da camp!", "Rrraaagh!"}, death = {"Ow! Ow!", "Boss... save... us..."}},
    {pattern = "Murloc|Bluegill|Coastrunner|Oracle", aggro = {"Mrrglrglrgl!", "Mmmrrrggglll!", "Aaaaaughaughaugh!", "Mrgle! Mrgle!"}, death = {"Mrrgl...", "Blrgl..."}},
    {pattern = "Dark Iron", aggro = {"For Ragnaros!", "The Firelord will burn you!", "Dark Iron never yields!", "Down to the forge with you!"}, death = {"Ragnaros... will... rise...", "Burn... all..."}},
}

local LAST = {}

local function Pick(t) return t[math.random(#t)] end

local ENTRY_PACK = {}
local count = 0
for _, pack in ipairs(PACKS) do
    if #pack.aggro > 0 then
        local pat = pack.pattern
        -- registered by entry: all templates whose name contains one of the pattern words (and are not vendors or quest givers)
        local words = {}
        for w in string.gmatch(pat, "[^|]+") do words[#words + 1] = "t.name LIKE '%" .. w .. "%'" end
        local q = WorldDBQuery("SELECT DISTINCT t.entry FROM creature_template t WHERE (" .. table.concat(words, " OR ") .. ") AND t.npcflag = 0 AND t.ScriptName = '' AND (SELECT COUNT(DISTINCT s.action_param1) FROM smart_scripts s WHERE s.entryorguid = t.entry AND s.source_type = 0 AND s.action_type IN (11, 85, 86, 134)) < 3 AND t.type IN (1, 2, 3, 4, 5, 6, 7, 9, 10) AND EXISTS (SELECT 1 FROM creature c WHERE c.id = t.entry) LIMIT 4000")
        if q then repeat
            local e = q:GetUInt32(0)
            if not ENTRY_PACK[e] then ENTRY_PACK[e] = pack; count = count + 1 end
        until not q:NextRow() end
    end
end

local function OnAggro(_, c, target)
    local pack = ENTRY_PACK[c:GetEntry()]
    if not pack then return end
    local g = tostring(c:GetGUIDLow())
    local now = os.time()
    if now - (LAST[g] or 0) < 20 or math.random(100) > 45 then return end
    LAST[g] = now
    pcall(function() c:SendUnitYell(Pick(pack.aggro), 0) end)
end

local function OnDied(_, c, killer)
    local pack = ENTRY_PACK[c:GetEntry()]
    if not pack or #pack.death == 0 or math.random(100) > 20 then return end
    pcall(function() c:SendUnitSay(Pick(pack.death), 0) end)
end

for e in pairs(ENTRY_PACK) do
    RegisterCreatureEvent(e, 1, OnAggro)     -- ENTER_COMBAT
    RegisterCreatureEvent(e, 4, OnDied)      -- DIED
end
print("[barks] " .. count .. " creature types bark in battle")
