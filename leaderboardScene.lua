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

local langId;

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

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local currentMode = _G.activeMode;
	local group = scene.view;
  langId = "IMG/";
  if (system.getPreference( "ui", "language") == "ru") then
    langId = "IMG/rus-";
  end
  local timeattackIcon, enduranceIcon, guesstimeIcon;
  
  local bg = display.newImageRect(group, "IMG/bgBlack.png", totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  
  local globalButton = ragdogLib.newSimpleButton(group, langId.."global.png", 91, 40);
  globalButton.x, globalButton.y = rightSide-5-globalButton.contentWidth*.5, topSide+5+globalButton.contentHeight*.5;
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
  
  local highscoreGroup = display.newGroup();
  group:insert(highscoreGroup);
  
  local createHighscore = function(currentMode)
    for i = highscoreGroup.numChildren, 1, -1 do
      highscoreGroup[i]:removeSelf();
    end
    local leaderboardTable = ragdogLib.getSaveValue("leaderboard"..currentMode) or {};
    if #leaderboardTable > 0 then
      for i = 1, #leaderboardTable do
        local name = display.newText(highscoreGroup, i..". "..leaderboardTable[i].name, 0, 0, native.systemFont, 22);
        name.x, name.y = bg.contentBounds.xMin+30+name.contentWidth*.5, topSide+50+(i*25);
        name:setFillColor(1, 1, 1);
        local score = display.newText(highscoreGroup, leaderboardTable[i].score, 0, 0, native.systemFont, 22);
        score.x, score.y = bg.contentBounds.xMax-30-score.contentWidth*.5, topSide+50+(i*25);
        score:setFillColor(1, 1, 1);
      end
    else
      local warning = display.newText(group, "There are no saved highscores yet!", 0, 0, native.systemFont, 16);
      warning.x, warning.y = bg.x, bg.y-30;
      warning:setFillColor(0, 0, 0);
    end
  end
  
  timeattackIcon = ragdogLib.newSimpleButton(group, "IMG/timeIcon.png", 60, 62);
  timeattackIcon.x, timeattackIcon.y = centerX-100, centerY+130;
  function timeattackIcon:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function timeattackIcon:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    if self.alpha < 1 then
      timeattackIcon.alpha = 1;
      enduranceIcon.alpha = 0.5;
      guesstimeIcon.alpha = 0.5;
      createHighscore("timeattack");
    end
  end
  
  enduranceIcon = ragdogLib.newSimpleButton(group, "IMG/enduIcon.png", 60, 62);
  enduranceIcon.x, enduranceIcon.y = centerX, centerY+130;
  enduranceIcon.alpha = 0.5;
  function enduranceIcon:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function enduranceIcon:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    if self.alpha < 1 then
      timeattackIcon.alpha = 0.5;
      enduranceIcon.alpha = 1;
      guesstimeIcon.alpha = 0.5;
      createHighscore("endurance");
    end
  end
  
  guesstimeIcon = ragdogLib.newSimpleButton(group, "IMG/guessIcon.png", 60, 62);
  guesstimeIcon.x, guesstimeIcon.y = centerX+100, centerY+130;
  guesstimeIcon.alpha = 0.5;
  function guesstimeIcon:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function guesstimeIcon:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    if self.alpha < 1 then
      timeattackIcon.alpha = 0.5;
      enduranceIcon.alpha = 0.5;
      guesstimeIcon.alpha = 1;
      createHighscore("guesstime");
    end
  end
  
  createHighscore("timeattack");
  
  local backButton = ragdogLib.newSimpleButton(group, "IMG/back.png", 59, 36);
  backButton.x, backButton.y = leftSide+5+backButton.contentWidth*.5, topSide+5+backButton.contentHeight*.5;
  function backButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function backButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("menuScene", "slideRight");
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