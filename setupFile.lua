--CHECK adsLib.lua TO ADD YOUR ADS KEYS
--CHECK build.settings TO FINALIZE SHARE/ADS
--CHECK gameScene.lua TO CHANGE OTHER PARAMETERS RELATED TO THE GAME
local ragdogLib = require "ragdogLib";
local adsLib = require "adsLib";
local networksLib = require "networksLib";

_G.twitterConsumerKey = "Your Twitter Consumer Key";
_G.twitterSecretKey = "Your Twitter Secret Key";
_G.facebookAPPID = "Your Facebook App ID";

_G.socialShareMessage = "I just made totalPoints in Avoid the White Tiles Template! http://bit.ly/1eDPypU";

_G.providerForFullscreenAds = "revmob"; --replace with either chartboost, revmob or admob
_G.providerForBannerAds = "chartboost"; --replace with either chartboost, revmob or admob

if not ragdogLib.getSaveValue("leaderboardendurance") then
  local leaderboardTable = {
    {name = "Carlo", score = 7.68},
    {name = "Cristian", score = 8.01},
    {name = "Martina", score = 8.54},
    {name = "Luca", score = 8.92},
    {name = "Serena", score = 9.45},
    {name = "Sara", score = 10.12},
    {name = "Luigi", score = 10.64},
    {name = "Laura", score = 11.12},
    {name = "Matteo", score = 13.45},
    {name = "Davide", score = 15.68}
  };
  ragdogLib.setSaveValue("leaderboardendurance", leaderboardTable, true);
end

if not ragdogLib.getSaveValue("leaderboardtimeattack") then
  local leaderboardTable = {
    {name = "Carlo", score = 7.68},
    {name = "Cristian", score = 8.01},
    {name = "Martina", score = 8.54},
    {name = "Luca", score = 8.92},
    {name = "Serena", score = 9.45},
    {name = "Sara", score = 10.12},
    {name = "Luigi", score = 10.64},
    {name = "Laura", score = 11.12},
    {name = "Matteo", score = 13.45},
    {name = "Davide", score = 15.68}
  };
  ragdogLib.setSaveValue("leaderboardtimeattack", leaderboardTable, true);
end

if not ragdogLib.getSaveValue("leaderboardguesstime") then
  local leaderboardTable = {
    {name = "Carlo", score = 7.68},
    {name = "Cristian", score = 8.01},
    {name = "Martina", score = 8.54},
    {name = "Luca", score = 8.92},
    {name = "Serena", score = 9.45},
    {name = "Sara", score = 10.12},
    {name = "Luigi", score = 10.64},
    {name = "Laura", score = 11.12},
    {name = "Matteo", score = 13.45},
    {name = "Davide", score = 15.68}
  };
  ragdogLib.setSaveValue("leaderboardguesstime", leaderboardTable, true);
end


--IF YOU WANT TO USE ADMOB, MAKE SURE TO TAKE A LOOK AT THE build.settings FILE AS WELL

local activeAdsProviders = {
  ["Android"] = {"revmob", "chartboost"}, -- replace revmob or chartboost with admob to ensure admob implementation
  ["iPhone OS"] = {"revmob", "chartboost"} -- replace revmob or chartboost with admob to ensure admob implementation
};

local activeNetworksProviders = {
  ["Android"] = {"google", {
      ["timeattack"] = "YOUR TIMEATTACK LEADERBOARD ID", 
      ["endurance"] = "YOUR ENDURANCE MODE LEADERBOARD ID", 
      ["guesstime"] = "YOUR GUESSTIME MODE LEADERBOARD ID"
  }}, --replace "google" with "none" if you don't use any leaderboard!
  ["iPhone OS"] = {"gamecenter", {
      ["timeattack"] = "YOUR TIMEATTACK LEADERBOARD ID", 
      ["endurance"] = "YOUR ENDURANCE MODE LEADERBOARD ID", 
      ["guesstime"] = "YOUR GUESSTIME MODE LEADERBOARD ID"
  }} --replace "gamecenter" with "none" if you don't use any leaderboard!
};

adsLib.init(activeAdsProviders);

local function systemEvents( event )
   if ( event.type == "applicationSuspend" ) then
   elseif ( event.type == "applicationResume" ) then
   elseif ( event.type == "applicationExit" ) then
   elseif ( event.type == "applicationStart" ) then
      networksLib.init(activeNetworksProviders);
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )