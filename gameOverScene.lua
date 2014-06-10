----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local shareLib = require "shareLib";
local adsLib = require "adsLib";

local help = require "help";



--let's localize these values for faster reading
local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

local buttonSFX = _G.buttonSFX;

local limitMin = _G.limitMin;
local limitMax = _G.limitMax;
local mRandom = math.random;


-- Called when the scene's view does not exist:
function scene:createScene( event )
--  adsLib.removeBannerAd();
--  adsLib.showFullscreenAd();
  
  local currentMode = _G.activeMode;
	local group = scene.view;
  
  local bg = display.newImageRect(group, help.imagePath("bgCloud"), totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  
  
  local scoreImage = display.newImageRect(group, help.localizableImage("score"), help.sizes(213,57));
  scoreImage.x, scoreImage.y = centerX, topSide + 0.01 * totalWidth + scoreImage.height / 2; 
  
  local scoreWindow = display.newImageRect(group, help.imagePath("screen_score"), help.sizes(384,410));
  scoreWindow.x, scoreWindow.y = centerX, topSide + scoreWindow.height / 2;
  
  local leavesBottom = display.newImageRect(group, help.imagePath("leaves_bottom"), 384, 227);
  leavesBottom.x, leavesBottom.y = centerX, bottomSide - leavesBottom.height / 2;
  
  if _G.finalScore then
    networksLib.addScoreToLeaderboard(_G.finalScore, currentMode);
  end
  
  local position = 200;
  if _G.finalScore then
    local leaderboardTable = ragdogLib.getSaveValue("leaderboard"..currentMode) or {};
    local currentScore = _G.finalScore or 0;
    local currentHighscore = (leaderboardTable[1] or {}).score or 0;local setInPosition = 1;
    for i = 1, #leaderboardTable do
        if leaderboardTable[i].score < currentScore then
          setInPosition = i+1;
        end
    end
    position = setInPosition;
    table.insert(leaderboardTable, setInPosition, {name = "YOU", score = currentScore});
    if #leaderboardTable > 10 then
      table.remove(leaderboardTable, 11);
    end
    ragdogLib.setSaveValue("leaderboard"..currentMode, leaderboardTable, true);
    local topText = display.newEmbossedText(group, _G.finalScore, 0, 0, "Helvetica-Bold", 30);
    topText:setFillColor(1, 1, 1);
    topText.x, topText.y = centerX, scoreWindow.y+scoreWindow.height / 3 +topText.contentHeight*.5;
  end
  
  local leaderboardTable = ragdogLib.getSaveValue("leaderboard"..currentMode) or {};
  if #leaderboardTable > 0 then
    for i = 1, #leaderboardTable do
      local name = display.newText(group, i..". "..leaderboardTable[i].name, 0, 0, native.systemFont, 18);
      name.x, name.y = bg.contentBounds.xMin+50+name.contentWidth*.5, topSide+70+0.01*totalHeight+(i*20);
      name:setFillColor(1, 1, 1);
      local score = display.newText(group, leaderboardTable[i].score, 0, 0, native.systemFont, 18);
      score.x, score.y = bg.contentBounds.xMax-50-score.contentWidth*.5, topSide+70+0.01*totalHeight+(i*20);
      score:setFillColor(1, 1, 1);
      if i == position then
        name:setFillColor(1, 0, 0);
        score:setFillColor(1, 0, 0);
      end
    end
  else
    local warning = display.newText(group, "There are no saved highscores yet!", 0, 0, native.systemFont, 16);
    warning.x, warning.y = bg.x, bg.y-30;
    warning:setFillColor(0, 0, 0);
  end
  
  local shareButton = ragdogLib.newSimpleButton(group, help.localizableImage("share"), help.sizes(110,38));
   shareButton.x, shareButton.y = centerX, bottomSide-0.17 * totalHeight;
   function shareButton:touchBegan()
     self:setFillColor(.5, .5, .5);
     self.xScale, self.yScale = .9, .9;
   end
   function shareButton:touchEnded()
     audio.play(buttonSFX, {channel = audio.findFreeChannel()});
     self:setFillColor(1, 1, 1);
     self.xScale, self.yScale = 1, 1;
     group:insert(shareLib.init(_G.socialShareMessage, {["totalPoints"] = (_G.finalScore or 0).."pts"}));
   end
  
  local retryButton = ragdogLib.newSimpleButton(group, help.localizableImage("play"), help.sizes(110,38));
  retryButton.x, retryButton.y = shareButton.x - shareButton.width, shareButton.y;
  function retryButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function retryButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    local currentMode = _G.activeMode;
    if currentMode == "timeattack" then
        help.generateArrayWithNumber(_G.coeficient);
        storyboard.gotoScene("gameScene");
    elseif currentMode == "endurance" then
        local x = mRandom(limitMin, limitMax);
        help.generateArrayWithNumber(x);
        storyboard.gotoScene("rookiePlayer");
    elseif currentMode == "guesstime" then
      storyboard.gotoScene("rookiePlayer");
    end
  end
  

  
  
  local menuButton = ragdogLib.newSimpleButton(group, help.localizableImage("menu"), help.sizes(110,38));
  menuButton.x, menuButton.y = shareButton.x + shareButton.width + menuButton.width / 4, shareButton.y;--centerX+60, bottomSide-76;
  function menuButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function menuButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("menuScene", "fade");
  end
  
  local globalButton = ragdogLib.newSimpleButton(group, help.localizableImage("best_score"), help.sizes(206,38));
  globalButton.x, globalButton.y = centerX, shareButton.y + 1.5 * shareButton.height;--centerX+60, bottomSide-120;
  function globalButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function globalButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    networksLib.showLeaderboard();
  end
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	local removeAll;
	
	removeAll = function(group)
		if group.enterFrame then
			Runtime:removeEventListener("enterFrame", group);
		end
		if group.touch then
			group:removeEventListener("touch", group);
			Runtime:removeEventListener("touch", group);
		end		
		for i = group.numChildren, 1, -1 do
			if group[i].numChildren then
				removeAll(group[i]);
			else
				if group[i].enterFrame then
					Runtime:removeEventListener("enterFrame", group[i]);
				end
				if group[i].touch then
					group[i]:removeEventListener("touch", group[i]);
					Runtime:removeEventListener("touch", group[i]);
				end
			end
		end
	end

	removeAll(group);
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------



return scene