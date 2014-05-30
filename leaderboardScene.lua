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

-- Called when the scene's view does not exist:
function scene:createScene( event )
  local currentMode = _G.activeMode;
  
	local group = scene.view;
  local timeattackIcon, enduranceIcon, guesstimeIcon;
  
  local bg = display.newImageRect(group, help.imagePath("bgCloud"), totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  
  local scoreImage = display.newImageRect(group, help.localizableImage("score"), help.sizes(213,57));
  scoreImage.x, scoreImage.y = centerX, topSide + 0.01 * totalWidth + scoreImage.height / 2; 
  
  local scoreWindow = display.newImageRect(group, help.imagePath("screen_score"), help.sizes(384,410));
  scoreWindow.x, scoreWindow.y = centerX, topSide + scoreWindow.height / 2;
  local globalButton = ragdogLib.newSimpleButton(group, help.localizableImage("best_score"), help.sizes(206,38));
  globalButton.x, globalButton.y = leftSide + 0.1 * totalWidth + globalButton.width / 2.75, bottomSide - globalButton.height/ 1.66;
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
  
  
  local backButton = ragdogLib.newSimpleButton(group, help.localizableImage("menu"), help.sizes(110,38));
  backButton.x, backButton.y = rightSide - 0.1 * totalWidth - backButton.width / 2.75, globalButton.y;
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
  
  
  local highscoreGroup = display.newGroup();
  group:insert(highscoreGroup);
  
  local createHighscore = function(currentMode)
    for i = highscoreGroup.numChildren, 1, -1 do
      highscoreGroup[i]:removeSelf();
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
      end
    else
      local warning = display.newText(group, "There are no saved highscores yet!", 0, 0, native.systemFont, 16);
      warning.x, warning.y = bg.x, bg.y-30;
      warning:setFillColor(0, 0, 0);
    end
  end
  
  timeattackIcon = ragdogLib.newSimpleButton(group, help.localizableImage("ace"), help.sizes(149, 61));
    local selectedImageX, selectedImageY = leftSide + timeattackIcon.width / 2.5, scoreImage.y + scoreImage.height / 1.5;
    local unselected1X, unselected1Y = centerX-100, centerY+150;
    local unselected2X, unselected2Y = centerX+100, centerY+150;
    
  timeattackIcon.x, timeattackIcon.y = selectedImageX, selectedImageY;
  function timeattackIcon:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function timeattackIcon:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    if self.alpha < 1 then
        
        timeattackIcon.x, timeattackIcon.y = selectedImageX, selectedImageY;
        enduranceIcon.x, enduranceIcon.y = unselected1X, unselected1Y;
        guesstimeIcon.x, guesstimeIcon.y = unselected2X, unselected2Y;
      timeattackIcon.alpha = 1;
      enduranceIcon.alpha = 0.5;
      guesstimeIcon.alpha = 0.5;
      createHighscore("timeattack");
    end
  end
  
  enduranceIcon = ragdogLib.newSimpleButton(group, help.localizableImage("pro_pilot"), help.sizes(149, 61));
  enduranceIcon.x, enduranceIcon.y = unselected1X, unselected1Y;
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
        enduranceIcon.x, enduranceIcon.y  = selectedImageX, selectedImageY;
        timeattackIcon.x, timeattackIcon.y = unselected1X, unselected1Y;
        guesstimeIcon.x, guesstimeIcon.y = unselected2X, unselected2Y;
      timeattackIcon.alpha = 0.5;
      enduranceIcon.alpha = 1;
      guesstimeIcon.alpha = 0.5;
      createHighscore("endurance");
    end
  end
  
  guesstimeIcon = ragdogLib.newSimpleButton(group, help.localizableImage("rookie"), help.sizes(149, 61));
  guesstimeIcon.x, guesstimeIcon.y = unselected2X, unselected2Y;
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
        guesstimeIcon.x, guesstimeIcon.y  = selectedImageX, selectedImageY;
        timeattackIcon.x, timeattackIcon.y = unselected1X, unselected1Y;
        enduranceIcon.x, enduranceIcon.y = unselected2X, unselected2Y;
      timeattackIcon.alpha = 0.5;
      enduranceIcon.alpha = 0.5;
      guesstimeIcon.alpha = 1;
      createHighscore("guesstime");
    end
  end
  
  createHighscore("timeattack");
  
  
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