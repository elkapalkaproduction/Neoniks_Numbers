display.setStatusBar(display.HiddenStatusBar);

local setupFile = require "setupFile";
local fpsLib = require "fpsLib";
local adsLib = require "adsLib";
local storyboard = require "storyboard";


storyboard.purgeOnSceneChange = true;

fpsLib.init();
local array = {};
array["iPhone OS"] = {};
array["iPhone OS"][1] = "revmob";
array["iPhone OS"][2] = "chartboost";
array["iPhone OS"][3] = "vungle";
array["iPhone OS"][4] = "playhaven";

array["Android"] = {};
array["Android"][1] = "revmob";
array["Android"][2] = "chartboost";
array["Android"][3] = "vungle";
array["Android"][4] = "playhaven";


adsLib.init(array);
_G.totalWidth = display.contentWidth-(display.screenOriginX*2);
_G.totalHeight = display.contentHeight-(display.screenOriginY*2);
_G.leftSide = display.screenOriginX;
_G.rightSide = display.contentWidth-display.screenOriginX;
_G.topSide = display.screenOriginY;
_G.bottomSide = display.contentHeight-display.screenOriginY;

_G.buttonSFX = audio.loadSound("SFX/wooshSFX.mp3");

_G.defaultImagesPath = "Images/";
_G.defaultImageExtension = ".png";

_G.timeToHide = 1;--in seconds;
_G.dissapearSound = "";

_G.numberOfOperation = 10;
_G.limitMin = 1;
_G.limitMax = 10;

_G.offsetDown = 0;

_G.siteEng = "http://www.neoniks.com";
_G.siteRus = "http://www.neoniki.ru";

--storyboard.gotoScene("LogoNeoniks", "fade");
 storyboard.gotoScene("menuScene", "fade");


