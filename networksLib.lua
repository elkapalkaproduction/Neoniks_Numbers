local networksLib = {};

local gameNetwork = require "gameNetwork";

local currentSystem = system.getInfo("platformName");
if currentSystem ~= "Android" and currentSystem ~= "iPhone OS" then
  currentSystem = "Android";
end

local activeNetworksProviders;
local currentNetwork;

local initializeFunctions = {
  ["google"] = function()
    gameNetwork.init("google", function(event) 
       gameNetwork.request("login", { userInitiated=true, listener=function()  print("User logged in google game services"); end });
    end);
  end,
  ["gamecenter"] = function()
    gameNetwork.init( "gamecenter", initCallback )
  end
};

networksLib.init = function(activeNetworks)
  activeNetworksProviders = activeNetworks;
  currentNetwork = activeNetworks[currentSystem][1];
  if initializeFunctions[currentNetwork] then
    initializeFunctions[currentNetwork]();
  end
end

networksLib.showLeaderboard = function()
  if currentNetwork == "google" then
    gameNetwork.show("leaderboards");
  elseif currentNetwork == "gamecenter" then
    gameNetwork.show("leaderboards", { leaderboard = {timeScope="AllTime"}});
  end
end

networksLib.addScoreToLeaderboard = function(score, mode)
  if currentNetwork == "google" then
    gameNetwork.request( "setHighScore",
    {
      localPlayerScore = { category= activeNetworksProviders[currentSystem][2][mode], value=tonumber(score) }, 
      listener = function() print("Score was posted"); end
    });
  elseif currentNetwork == "gamecenter" then
    gameNetwork.request( "setHighScore",
    {
        localPlayerScore = { category=activeNetworksProviders[currentSystem][2][mode], value=tonumber(score) },
        listener= function() print("Score was posted"); end
    })
  end
end

return networksLib;