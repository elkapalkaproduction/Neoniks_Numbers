----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ragdogLib = require "ragdogLib";

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
 
 local group = scene.view;
 
 local bgGeneral = display.newImageRect(group, help.imagePath("bgCloud"), totalWidth, totalHeight);
 bgGeneral.x, bgGeneral.y = centerX, centerY;
  
  local desk = display.newImageRect(group, help.imagePath("desk"), help.sizes(254,170));
  desk.x, desk.y = rightSide - desk.width / 2, bottomSide - desk.height / 2;
  
  local topView = display.newImageRect(group, help.imagePath("screen_menu"), help.sizes(384,311));
  topView.x, topView.y = leftSide + topView.width / 2, topSide + topView.height / 2;
  
  local textImage = display.newImageRect(group, help.localizableImage("text_menu"), help.sizes(288,114));
  textImage.x, textImage.y = centerX, topSide + 0.45 * topView.height + textImage.height / 2;
  
  local magicSchoolTop = display.newImageRect(group, help.localizableImage("magic_school"), help.sizes(384,78));
  magicSchoolTop.x, magicSchoolTop.y = leftSide + magicSchoolTop.width / 2, topSide + magicSchoolTop.height / 2;
  
  local multiplication = display.newImageRect(group, help.localizableImage("multiplication"), help.sizes(170,30));
  multiplication.x, multiplication.y = centerX, topSide + 0.29 * topView.height + multiplication.height / 2;
  
  

  
  local guessButton = ragdogLib.newSimpleButton(group, help.localizableImage("rookie"), help.sizes(149, 61));
  guessButton.x, guessButton.y = leftSide + 0.02 * totalWidth + guessButton.width / 2, topSide + topView.height + guessButton.height / 2;
  function guessButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function guessButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    _G.activeMode = "guesstime";
    help.generateArrayWithNumber(2);
    storyboard.gotoScene("rookiePlayer");
  end
  
  
  local enduranceButton = ragdogLib.newSimpleButton(group, help.localizableImage("pro_pilot"), help.sizes(149, 61));
  enduranceButton.x, enduranceButton.y = guessButton.x + 0.02 * totalWidth, guessButton.y + enduranceButton.height;
  function enduranceButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function enduranceButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    _G.activeMode = "endurance";
    local x = mRandom(limitMin, limitMax);
    help.generateArrayWithNumber(x);
    storyboard.gotoScene("rookiePlayer");
  end
  
  local timeattackButton = ragdogLib.newSimpleButton(group, help.localizableImage("ace"), help.sizes(149, 61));
  timeattackButton.x, timeattackButton.y = enduranceButton.x + 0.02 * totalWidth, enduranceButton.y + enduranceButton.height;
  function timeattackButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function timeattackButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    _G.activeMode = "timeattack";
    help.generateArrayWithNumber(-1);
    storyboard.gotoScene("gameScene");
  end
  
  
  local scoresButton = ragdogLib.newSimpleButton(group, help.localizableImage("pig"), help.sizes(109, 115));
  scoresButton.x, scoresButton.y = rightSide - 0.1 * totalWidth - scoresButton.width / 2, topSide + topView.height + scoresButton.height / 2 - 0.06 * totalHeight;
  function scoresButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function scoresButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("leaderboardScene", "slideLeft");
  end
  
  
  local whatButton = ragdogLib.newSimpleButton(group, help.localizableImage("what_is_magic_school"), help.sizes(367,35));
  whatButton.x, whatButton.y = centerX, bottomSide - whatButton.height / 2;
  function whatButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function whatButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("infoNeoniks");
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