----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local fpsLib = require "fpsLib";
local timeInterval = 1000;

local adsLib = require "adsLib"; 
local help = require "help";

local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;  

local limitMin = _G.limitMin;
local limitMax = _G.limitMax;
local mRandom = math.random;

local currentMode;

function scene:createScene( event )
	local group = scene.view;
  local userSelectNumber = false;
    local bg = display.newImageRect(group, help.imagePath("bgCloud"), totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  function bg:touch(event)
    return true;
  end
  bg:addEventListener("touch", bg);
  
  local bgLeaves = display.newImageRect(group, help.imagePath("background_leaves"), help.sizes(193, 141));
  bgLeaves.x, bgLeaves.y = rightSide - bgLeaves.width / 2, bottomSide - bgLeaves.height / 2;
  
  local bgTop = display.newImageRect(group, help.imagePath("tut_background_top"), help.sizes(384, 330));
  bgTop.x, bgTop.y = centerX, topSide + bgTop.height / 2;
    currentMode = _G.activeMode;

  local tutTextPath, persW, persH;
  if currentMode == "timeattack" then
    tutTextPath, persW, persH = "tut_ace", 369, 343;
  elseif currentMode == "endurance" then
    tutTextPath, persW, persH = "tut_pro_pilot", 318, 253;
  elseif currentMode == "guesstime" then
    tutTextPath, persW, persH = "tut_rookie", 244, 245;
  end

  local tutTextImage = display.newImageRect(group, help.localizableImage("text_"..tutTextPath), help.sizes(306,90));
  tutTextImage.x, tutTextImage.y = centerX, topSide + 0.3 * bgTop.height + tutTextImage.height / 2;
  
  local tutClassIcon = display.newImageRect(group, help.localizableImage(tutTextPath), help.sizes(84,62));
  tutClassIcon.x, tutClassIcon.y = leftSide + 0.185 * totalWidth + tutClassIcon.width / 2, topSide + 0.115 * bgTop.height + tutClassIcon.height / 2;
  local width, height =  help.sizes(persW,persH);
  if (totalHeight == 568) then
    width, height = width * 1.3, height * 1.3
  end
  local tutPersImage = display.newImageRect(group, help.imagePath("pers_"..tutTextPath), width, height);
  tutPersImage.x, tutPersImage.y = leftSide + tutPersImage.width / 2, bottomSide - tutPersImage.height / 2;

  local button2 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/2"), help.sizes(35, 40));
  local button3 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/3"), help.sizes(35, 40));
  local button4 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/4"), help.sizes(35, 40));
  local button5 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/5"), help.sizes(35, 40));
  local button6 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/6"), help.sizes(35, 40));
  local button7 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/7"), help.sizes(35, 40));
  local button8 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/8"), help.sizes(35, 40));
  local button9 = ragdogLib.newSimpleButton(group, help.imagePath("numbers/9"), help.sizes(35, 40));


  button2.x, button2.y = centerX - 7 * button2.width / 2 , bgTop.y + button2.height / 2;
  button3.x, button3.y = centerX - 5 * button3.width / 2, button2.y;
  button4.x, button4.y = centerX - 3 * button4.width / 2, button3.y;
  button5.x, button5.y = centerX - button5.width / 2, button4.y;
  button6.x, button6.y = centerX + button6.width / 2, button5.y;
  button7.x, button7.y = centerX + 3 * button7.width / 2, button6.y;
  button8.x, button8.y = centerX + 5 * button8.width / 2, button7.y;
  button9.x, button9.y = centerX + 7 * button9.width / 2, button8.y;
  local alphaMic = 0.5;
  local function setAlphaZero()
    button2.alpha = alphaMic;
    button3.alpha = alphaMic;
    button4.alpha = alphaMic;
    button5.alpha = alphaMic;
    button6.alpha = alphaMic;
    button7.alpha = alphaMic;
    button8.alpha = alphaMic;
    button9.alpha = alphaMic;
  end
  setAlphaZero();
  if currentMode == "guesstime" then 
  function button2:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button2:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button2.alpha = 1;
    help.generateArrayWithNumber(2);
    userSelectNumber = true
  end 
  
  
  function button3:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button3:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button3.alpha = 1;
    help.generateArrayWithNumber(3);
    userSelectNumber = true
  end  
  
  
  function button4:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button4:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button4.alpha = 1;
    help.generateArrayWithNumber(4);
    userSelectNumber = true
  end  
  
  
  function button5:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button5:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button5.alpha = 1;
    help.generateArrayWithNumber(5);
    userSelectNumber = true
  end  
  
  
  function button6:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button6:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button6.alpha = 1;
    help.generateArrayWithNumber(6);
    userSelectNumber = true
  end  
  
  
  function button7:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button7:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button7.alpha = 1;
    help.generateArrayWithNumber(7);
    userSelectNumber = true
  end 
  
  
  function button8:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button8:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button8.alpha = 1;
    help.generateArrayWithNumber(8);
    userSelectNumber = true
  end 
  
  
  function button9:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function button9:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    setAlphaZero();
    button9.alpha = 1;
    help.generateArrayWithNumber(9);
    userSelectNumber = true
  end
  elseif currentMode == "endurance" then
  x = _G.coeficient;
    if x == 2 then
      button2.alpha = 1;
    elseif x == 3 then
      button3.alpha = 1;  
    elseif x == 4 then
      button4.alpha = 1;  
    elseif x == 5 then
      button5.alpha = 1;
    elseif x == 6 then
      button6.alpha = 1;  
    elseif x == 7 then
      button7.alpha = 1; 
    elseif x == 8 then
      button8.alpha = 1;  
    elseif x == 9 then
      button9.alpha = 1;
    end
end
  local nextButton = ragdogLib.newSimpleButton(group, help.localizableImage("play"), help.sizes(110, 38));
  nextButton.x, nextButton.y = rightSide - nextButton.width / 2, bottomSide - nextButton.height / 1.5;
  function nextButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function nextButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    if userSelectNumber then
        storyboard.gotoScene("gameScene");
    end
    if currentMode == "endurance" then
      storyboard.gotoScene("gameScene");
  end
  end
  
  local backButton = ragdogLib.newSimpleButton(group, help.localizableImage("menu"), help.sizes(110, 38));
  backButton.x, backButton.y = nextButton.x, nextButton.y - backButton.height;
  function backButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end 
  function backButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("menuScene");
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