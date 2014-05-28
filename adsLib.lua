local revmob, chartboost, ads, tapfortap;

local revMobAndroidAppId = "537d1092ee7f67f1625d621f";
local revMobIosAppId = "53726c04d05eac4f34ea92fd";

local chartBoostAppId = "53726b8c1873da7f2ac823bb";
local chartBoostAppSignature = "9d5fab837feda532654ac521134916acb40150af";
local chartBoostAppVersion = "1.0";

local adMobAppIdBanner = "Set your adMob Ad ID for banner here";
local adMobAppIdInterstitial = "Set your adMob Ad ID for interstitials here";

local tapForTapKey = "Set your TapForTap key here";

local iAdsAppID = "Set your iAds App ID here";

local provider = "vungle";
local vungleAds = require "ads";
local vungleAppId = "53726cd8b0d954ab310001e6";

local playhaven = require "plugin.playhaven";
local playHavenToken = "b388eae13c764d2a925408dc15d74329";
local playHavenSecret = "44af2c622d004266a94a395ed17546eb";

local revmobOnStart = { ["Android"] = "on_game_start_revmob_android", ["iPhone OS"] = "on_game_start_revmob" }
local revmobOnFinish = { ["Android"] = "on_game_end_revmob_android", ["iPhone OS"] = "on_game_end_revmob" }

local currentSystem = system.getInfo("platformName");
currentSystem = (currentSystem == "Android" or currentSystem == "iPhone OS") and currentSystem or "iPhone OS";

local adsLib = {};


local initializeFunctions = {
  ["revmob"] = function()
    revmob = require "adsLib.revmob.revmob";
    revmob.startSession({["Android"] = revMobAndroidAppId, ["iPhone OS"] = revMobIosAppId });
  end,
  ["chartboost"] = function()
    chartboost = require "adsLib.chartboost.chartboost";
    chartboost.create{
      appId = chartBoostAppId,
      appSignature = chartBoostAppSignature,
      appVersion = chartBoostAppVersion,
      delegate = {}
    };
    chartboost.startSession();
    chartboost.cacheInterstitial();
  end,
  ["admob"] = function()
    ads = require "ads";
    local adMobAppId = adMobAppIdBanner;
    if _G.providerForFullscreenAds == "admob" then
      adMobAppId = adMobAppIdBanner;
    end
    ads.init("admob", adMobAppId);
  end,
  ["tapfortap"] = function()
    tapfortap = require "plugin.tapfortap";
    tapfortap.initialize(tapForTapKey);
    tapfortap.prepareInterstitial();
  end,
  ["iads"] = function()
    ads.init("iads", iAdsAppID)
  end,
  ["vungle"] = function ()
    vungleAds.init( provider, vungleAppId);
  end,
  ["playhaven"] = function ()
    local init_options = {
    token = playHavenToken,
    secret = playHavenSecret,
  }
  playhaven.init(playhavenListener, init_options)
  end
};

adsLib.init = function(activeAds)
  for i = 1, #activeAds[currentSystem] do
    initializeFunctions[activeAds[currentSystem][i]]();
  end
end

local revmobListener = function(event)
end

adsLib.showFullscreenAd = function(provider)
  if provider == "revmob" and revmob then
    revmob.showFullscreen(revmobListener, revmobOnStart);
  elseif provider == "chartboost" and chartboost then

    if chartboost.hasCachedInterstitial() then
      chartboost.showInterstitial();
    else
      chartboost.cacheInterstitial();
    end
  elseif provider == "tapfortap" and tapfortap then
    if tapfortap and tapfortap.interstitialIsReady() then
      tapfortap.showInterstitial();
    end
  elseif provider == "admob" and ads then
    ads.show("interstitial", {appId = adMobAppIdInterstitial});
  elseif provider == "vungle" and vungleAds then
    vungleAds.show( "interstitial", { isBackButtonEnabled = true } );
  elseif provider == "playhaven" then
    playhaven.contentRequest("on_game_start", true);
  end
end

adsLib.showAppWall = function()
  local provider = _G.providerForAppWall;
  if provider == "tapfortap" and tapfortap then
    tapfortap.showAppWall();
  end
end
adsLib.showFullscreenOnFinish = function(provider)
if provider == "revmob" and revmob then
    revmob.showFullscreen(revmobListener, revmobOnFinish);
    elseif provider == "playhaven" then 
          playhaven.contentRequest("on_game_end", true);
    elseif provider == "chartboost" then
      chartboost.showMoreApps();
      end
end
adsLib.showBannerAd = function(position)
  --position = "bottom";
  local provider = _G.providerForBannerAds;
  if provider == "revmob" and revmob then
    local xPos, yPos, width, height;
    if position == "top" then
      width, height = _G.totalWidth, 50-display.screenOriginY;
      xPos, yPos = display.contentCenterX, _G.topSide+height*.5;
    elseif position == "bottom" then
      width, height = _G.totalWidth, 50-display.screenOriginY;
      xPos, yPos = display.contentCenterX, _G.bottomSide-height*.5;
    end
    adsLib.currentBanner = {revmob.createBanner({x = xPos, y = yPos, width = width, height = height}), provider};
  elseif provider == "admob" and ads then
    local xPos, yPos, width, height;
    if position == "top" then
      xPos, yPos = display.screenOriginX, display.screenOriginY;
      if totalHeight == 568 then
        yPos = 0;
      end
    elseif position == "bottom" then
      xPos, yPos = display.screenOriginX, _G.bottomSide-40;
    end
    ads.show("banner", {interval = 50, x = xPos, y = yPos, appId = adMobAppIdBanner});
  elseif provider == "iads" and ads then
    local xPos, yPos, width, height;
    if position == "top" then
      xPos, yPos = display.screenOriginX, display.screenOriginY;
    elseif position == "bottom" then
      xPos, yPos = display.screenOriginX, _G.bottomSide-40;
    end
    ads.show("banner", {interval = 50, x = xPos, y = yPos});
  end
end

adsLib.removeBannerAd = function()
  local provider = _G.providerForBannerAds;
  if adsLib.currentBanner then
    local provider = adsLib.currentBanner[2];
    if provider == "revmob" and revmob then
      adsLib.currentBanner[1]:release();
      adsLib.currentBanner = nil;
    end
  else
    if provider == "admob" and ads then
      ads.hide();
    end
  end
end

return adsLib;