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
}

local gamechecker = { -- i add this because the group had diff game
    [13704594433] = 'https://raw.githubusercontent.com/fileagent/Constlynhub/refs/heads/main/games/the%20storage.lua',
}

if gamechecker[game.PlaceId] then
    loadstring(game:HttpGet(gamechecker[game.PlaceId]))()
elseif Constlynhub[game.CreatorId] then
    loadstring(game:HttpGet(Constlynhub[game.CreatorId]))()
else
    warn("ConstlynHub: No script found for this game.")
end
