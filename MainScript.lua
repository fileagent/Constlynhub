--[[local Constlynhub = {
    [682912579] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/orderup.lua',
    [8918098] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/notoriety.lua',
}
local gamechecker = { -- i add this because the group had diff game
 [13704594433] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/the%20storage.lua',
}
if not game.PlaceId == gamechecker then
loadstring(game:HttpGet(Constlynhub[game.CreatorId]))()
else
loadstring(game:HttpGet(gamechecker[game.PlaceId]))()]]
local Constlynhub = {
    [682912579] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/orderup.lua',
    [8918098] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/notoriety.lua',
    [82029620] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/one%20more%20night.lua',
    [5353743] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/hybridcafe.lua',
    [75128155] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/sneakthief.lua',
    [33242376] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/trepassershitgame.lua',
}

local gamechecker = { -- i add this because the group had diff game
    [13704594433] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/the%20storage.lua',
    [6891812658] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/clawmachine.lua', -- example
    [6737669488] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/RaceOrDie(FakeUGC)',
    [90070078747190] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/Click%20for%20ugc2'
}

if gamechecker[game.PlaceId] then
    loadstring(game:HttpGet(gamechecker[game.PlaceId]))()
elseif Constlynhub[game.CreatorId] then
    loadstring(game:HttpGet(Constlynhub[game.CreatorId]))()
else
    warn("ConstlynHub: No script found for this game.")
end
