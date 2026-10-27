-- Temporary GM helper: play a pre-rendered movie or an in-engine cinematic by ID
-- without the server-side Movie/CinematicSequences DB2 check.
-- .movietest <movieId>   -> SMSG_TRIGGER_MOVIE
-- .cine <sequenceId>     -> SMSG_TRIGGER_CINEMATIC
local function OnChat(event, player, msg, Type, lang)
    if player:GetGMRank() < 2 then
        return
    end

    local movie = msg:match("^%.movietest%s+(%d+)$")
    if movie then
        player:SendMovieStart(tonumber(movie))
        player:SendBroadcastMessage("movie " .. movie)
        return false
    end

    local cine = msg:match("^%.cine%s+(%d+)$")
    if cine then
        player:SendCinematicStart(tonumber(cine))
        player:SendBroadcastMessage("cinematic " .. cine)
        return false
    end
end

RegisterPlayerEvent(18, OnChat)
print("[movie_test] loaded")
