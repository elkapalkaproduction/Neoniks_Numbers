----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------



local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ragdogLib = require "ragdogLib";
local fpsLib = require "fpsLib";
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

local createTiles;
local createHud;
local createShoes;
local createTutorial;
local activateCountDown;
local gameLayer;
local hudLayer;

local beepSFX;
local buzzSFX;
local breakSFX;
local stepSFX;

local currentMode;
local currentTime;
local startTime;
local currentScore;


local delayBeforeShowingGameOver = 60; 

local operationText;

local timeAttackNumberOfTiles = _G.numberOfOperation;

local scrollSpeed = 15;
local tilesSheet;
local activeRowTile;
local shoesPool;


local mCeil, mRandom = math.ceil, math.random;

activateCountDown = function(group)
  local countGroup = display.newGroup();
  group:insert(countGroup);
  
  local bg = display.newImageRect(countGroup, help.imagePath("bgCloud"), totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  function bg:touch(event)
    return true;
  end
  bg:addEventListener("touch", bg);
  

  local text3 = display.newImageRect(countGroup, help.imagePath("3"), help.sizes(68, 167));
  text3.x, text3.y = centerX, centerY;
  local text2 = display.newImageRect(countGroup, help.imagePath("2"), help.sizes(54, 167));
  text2.x, text2.y = centerX, centerY;
  text2.alpha = 0;
  local text1 = display.newImageRect(countGroup, help.imagePath("1"), help.sizes(41, 167));
  text1.x, text1.y = centerX, centerY;
  text1.alpha = 0;
  
  audio.play(beepSFX, {channel = audio.findFreeChannel()});
  transition.from(text3, {time = 400, xScale = 3, yScale = 3});
  transition.to(text3, {delay = 600, time = 400, xScale = .5, yScale = .5, alpha = 0, onComplete = function() 
    audio.play(beepSFX, {channel = audio.findFreeChannel()});
    text2.alpha = 1; 
  end});
  transition.from(text2, {delay = 1000, time = 400, xScale = 3, yScale = 3});
  transition.to(text2, {delay = 1600, time = 400, xScale = .5, yScale = .5, alpha = 0, onComplete = function() 
    audio.play(beepSFX, {channel = audio.findFreeChannel()});
    text1.alpha = 1; 
  end});
  transition.from(text1, {delay = 2000, time = 400, xScale = 3, yScale = 3});
  transition.to(text1, {delay = 2600, time = 400, xScale = .5, yScale = .5, alpha = 0, onComplete = function()
     countGroup:removeSelf();
     startTime = os.time();
  end});
end

createTutorial = function(group)
  local tutGroup = display.newGroup();
  group:insert(tutGroup);
  
  local bg = display.newImageRect(tutGroup, help.imagePath("bgCloud"), totalWidth, totalHeight);
  bg.x, bg.y = centerX, centerY;
  function bg:touch(event)
    return true;
  end
  bg:addEventListener("touch", bg);
  
  local bgLeaves = display.newImageRect(tutGroup, help.imagePath("background_leaves"), help.sizes(193, 141));
  bgLeaves.x, bgLeaves.y = rightSide - bgLeaves.width / 2, bottomSide - bgLeaves.height / 2;
  
  local bgTop = display.newImageRect(tutGroup, help.imagePath("tut_background_top"), help.sizes(384, 330));
  bgTop.x, bgTop.y = centerX, topSide + bgTop.height / 2;
  
  local tutTextPath, persW, persH;
  if currentMode == "timeattack" then
    tutTextPath, persW, persH = "tut_ace", 369, 343;
  elseif currentMode == "endurance" then
    tutTextPath, persW, persH = "tut_pro_pilot", 318, 253;
  elseif currentMode == "guesstime" then
      tutTextPath, persW, persH = "tut_rookie", 244, 245;
    tutGroup:removeSelf();
    activateCountDown(group);
end
  
  local tutTextImage = display.newImageRect(tutGroup, help.localizableImage("text_"..tutTextPath), help.sizes(306,90));
  tutTextImage.x, tutTextImage.y = centerX, topSide + 0.3 * bgTop.height + tutTextImage.height / 2;
  
  local tutClassIcon = display.newImageRect(tutGroup, help.localizableImage(tutTextPath), help.sizes(84,62));
  tutClassIcon.x, tutClassIcon.y = leftSide + 0.185 * totalWidth + tutClassIcon.width / 2, topSide + 0.115 * bgTop.height + tutClassIcon.height / 2;
  
  local tutPersImage = display.newImageRect(tutGroup, help.imagePath("pers_"..tutTextPath), help.sizes(persW,persH));
  tutPersImage.x, tutPersImage.y = leftSide + tutPersImage.width / 2, bottomSide - tutPersImage.height / 2;
    
  
  local nextButton = ragdogLib.newSimpleButton(tutGroup, help.localizableImage("play"), help.sizes(110, 38));
  nextButton.x, nextButton.y = rightSide - nextButton.width / 2, bottomSide - nextButton.height / 1.5;
  function nextButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function nextButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    tutGroup:removeSelf();
    activateCountDown(group);
  end
  
  local backButton = ragdogLib.newSimpleButton(tutGroup, help.localizableImage("menu"), help.sizes(110, 38));
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

createShoes = function(group, side)
  shoesPool = shoesPool or {};
  shoesPool[side] = shoesPool[side] or {};
  
  local shoe = display.newImageRect(group, help.imagePath("player"), help.sizes(33, 86));
  shoe.rotation = mRandom(-10, 10);
  if side == 2 then
    shoe.xScale = -1;
  end
  
  function shoe:activate(group, xPos, yPos)
    group:insert(shoe);
    shoe.x, shoe.y = xPos, yPos;
    shoe.isVisible = true;
  end
  
  function shoe:deactivate()
    shoesPool[side][#shoesPool[side]+1] = shoe;
    shoe.isVisible = false;
    scene.view:insert(shoe);
    shoe.x, shoe.y = -1000, -1000;
  end
  
  shoe:deactivate();
end

createHud = function(group)
  local stopText;
  local timeToAdd;
    currentTime = 0;
    currentScore = 0;
    timeToAdd = 1/60;
   local topImage = display.newImageRect(group, help.imagePath("top"), help.sizes(384, 106));
  topImage.x, topImage.y = leftSide + topImage.width / 2, topSide + topImage.height / 2;
  
  
  local timeText = display.newEmbossedText(group, currentTime, leftSide + 0.85 * totalWidth + 20, topSide + 0.1 * topImage.height, native.systemFont, 20);
  timeText:setFillColor(1, 1, 1);
  
  local scoreText = display.newEmbossedText(group, currentScore, leftSide + 0.125 * totalWidth + 12.5, topSide + 0.1 * topImage.height + 12.5, native.systemFont, 20);
  scoreText:setFillColor(1, 1, 1);
  
  operationText = display.newEmbossedText(group, currentTime, centerX, topSide + topImage.height / 2 - 10, native.systemFont, 30);
  operationText:setFillColor(0,0,0);
  function timeText:enterFrame()
    if gameLayer.gameOver or not startTime then
      return;
    end
    local FPS = fpsLib.FPS;
    local firstNumber = _G.randomNumber["first"][currentScore + 1];
    local secondNumber = _G.randomNumber["second"][currentScore + 1];
    operationText:setText(firstNumber.." x "..secondNumber.." = ?");
    scoreText:setText(currentScore);
    currentTime = currentTime+timeToAdd*FPS;
    local currentTime = currentTime*100;
    currentTime = currentTime-(currentTime%1);
    local needsZero = 0;
    if string.sub(tostring(currentTime), #tostring(currentTime), #tostring(currentTime)) == "0" then
      needsZero = needsZero+1;
      if string.sub(tostring(currentTime), #tostring(currentTime)-1, #tostring(currentTime)-1) == "0" then
        needsZero = needsZero+1;
      end
    end
    currentTime = currentTime-(currentTime%1);
    currentTime = currentTime*.01;
    
    if needsZero >= 2 then
      currentTime = currentTime..".";
    end
    for i = 1, needsZero do
      currentTime = currentTime.."0";
    end
    self:setText(currentTime);
  end
  Runtime:addEventListener("enterFrame", timeText);
  
 
end

createTiles = function(group)
  local timeAttackNumberOfTiles = timeAttackNumberOfTiles;
  local textGroup = display.newGroup();
  local options = {
    width = 80,
    height = 111,
    numFrames = 4,
    sheetContentWidth = 240, 
    sheetContentHeight = 222 
  };
  tilesSheet = graphics.newImageSheet(help.imagePath("tileSheet"), options);
  
    local tileAnim = {
      {name = "white", start = 3, count = 1, time = 0},
      {name = "black", start = 3, count = 1, time = 0},
      {name = "yellow", start = 2, count = 1, time = 0},
      {name = "broken", start = 4, count = 1, time = 0}
    };
  
  local totalRows = mCeil(totalHeight/options.height)+1;
  local totalColumns = mCeil(totalWidth/options.width);
  
  if totalColumns%2 ~= 0 then
    totalColumns = totalColumns+1;
  end
  local firstTile = (totalColumns-4)*.5+1;
  local lastTile = firstTile+3;
  
  local lastTiles = {contentHeight = 0, y = topSide-40};
  
  for i = 1, totalRows do
    local tileGroup = display.newGroup();
    group:insert(tileGroup);
    
    for a = 1, totalColumns do
      local tile = display.newSprite(tileGroup, tilesSheet, tileAnim);
      tile.x = a*options.width;
      tile.position = a-(firstTile-1);
      tile.checkPosition = tile.position;
      if a <= firstTile then
        tile.checkPosition = 1;
      elseif a >= lastTile then
        tile.checkPosition = 4;
      end
      
      function tile:touch(event)
        if event.phase == "began" and not gameLayer.gameOver then
          if gameLayer.timerReached then
            audio.play(breakSFX, {channel = audio.findFreeChannel()});
            gameLayer.gameOver = true;
            return;
          end
            if activeRowTile[self.checkPosition].sequence == "black" then
            audio.play(stepSFX, {channel = audio.findFreeChannel()});
            currentScore = currentScore+1;
            local shoe;
            if self.checkPosition > 2 then
              shoe = shoesPool[2][#shoesPool[2]];
              shoesPool[2][#shoesPool[2]] = nil;
            else
              shoe = shoesPool[1][#shoesPool[1]];
              shoesPool[1][#shoesPool[1]] = nil;
            end
            if shoe then
              shoe:activate(activeRowTile, activeRowTile[self.checkPosition].x, activeRowTile[self.checkPosition].y);
              activeRowTile.shoe = shoe;
            end
 
            gameLayer.newPosition = gameLayer.newPosition+options.height;
            activeRowTile = activeRowTile.prevGroup;
            if activeRowTile[1].sequence == "yellow" then
              gameLayer.gameOver = true;
              gameLayer.success = true;
              _G.finalScore = currentTime;
              _G.finalScore = _G.finalScore*100;
              _G.finalScore = _G.finalScore-(_G.finalScore%1);
              _G.finalScore = _G.finalScore*.01;
            end
          else
            audio.play(breakSFX, {channel = audio.findFreeChannel()});
            gameLayer.gameOver = true;
            activeRowTile[self.checkPosition]:setSequence("broken");
          end
        end
      end
      tile:addEventListener("touch", tile);
    end
    
    for a = 4, 1, -1 do
      tileGroup:insert(1, tileGroup[3+firstTile]);
    end
    
    tileGroup.position = i;
    tileGroup.anchorChildren = true;
    tileGroup.x, tileGroup.y = centerX, lastTiles.y+lastTiles.contentHeight*.5+tileGroup.contentHeight*.5;
    
    tileGroup.prevGroup = lastTiles;
    lastTiles.nextGroup = tileGroup;
    
    function tileGroup:updateBlackTile()
      local blacktile = mRandom(1, 4)
      
      if self.position > timeAttackNumberOfTiles then
        for i = 1, self.numChildren do
          self[i]:setSequence("yellow");
        end
        return;
      end
        local x = self.position;
    if totalRows == 6 then
        if x == 4 then 
            x = 1;
        elseif x == 3 then
            x = 2;
        elseif x == 2 then
            x = 3; 
        elseif x == 1 then
            x = 4;
        else 
            x = x - 2;
        end 
    else 
        if x == 5 then 
            x = 1;
        elseif x == 4 then
            x = 2;
        elseif x == 3 then
            x = 3; 
        elseif x == 2 then
            x = 4;
        elseif x == 1 then 
            x = 5;
        else 
            x = x - 2;
        end
    end
        local firstNumber = _G.randomNumber["first"][x];
        local secondNumber = _G.randomNumber["second"][x];
        x = firstNumber * secondNumber;
        for i = 1, self.numChildren do
          self[i]:setSequence("white");
          local randomCoeficient;
          repeat
          randomCoeficient = mRandom(x + self[i].position*5, x + self[i].position*5 + 5);
          randomCoeficient = math.abs(x - randomCoeficient);
          until (randomCoeficient ~= x);
            local posX = (0.125+0.25*(self[i].position-1))*totalWidth;
            if (totalColumns == 6) then
              posX = options.width*(self[i].position-.5);
            end
          local text = display.newText( ""..randomCoeficient, posX, self.y, "Helvetica-Bold", 32);
          text:setTextColor( 1, 1, 1)
          if self[i].position > 0 and self[i].position < 5 then
          textGroup:insert (text); end
          if self[i].position == blacktile then
            text.text = x;
            self[i]:setSequence("black");
          end
        end
      end
    
    function tileGroup:enterFrame()
      if self.contentBounds.yMin > totalHeight then
        self.y = self.nextGroup.y-self.contentHeight;
        if self.shoe then
          self.shoe:deactivate();
          self.shoe = nil;
        end
        if self.position == totalRows then
          self.position = self.position+1;
        else
          self.position = self.nextGroup.position+1;
        end
        self:updateBlackTile();
        Runtime:removeEventListener("enterFrame", self);
        Runtime:addEventListener("enterFrame", self.prevGroup);
      end
    end
    
    if i == totalRows then
      group[1].prevGroup = tileGroup;
      tileGroup.nextGroup = group[1];
      Runtime:addEventListener("enterFrame", tileGroup);
    end
    
    lastTiles = tileGroup;
    
    tileGroup:updateBlackTile()
  end
  activeRowTile = group[group.numChildren-1].prevGroup;
  for i = group.numChildren-1, group.numChildren do
    for a = 1, 4 do
      group[i][a]:setSequence("yellow");
    end
  end
      local numberOfChildTextGroup = textGroup.numChildren;
    for i=1,numberOfChildTextGroup do
      if i > 4 * (totalRows - 2) then
        numberOfDisplayedCells = numberOfChildTextGroup - 8;
      textGroup[i].text = "";
      end
    end
  timeAttackNumberOfTiles = timeAttackNumberOfTiles+2;
  group:insert(textGroup);
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
  beepSFX = audio.loadSound("SFX/Beep.mp3");
  buzzSFX = audio.loadSound("SFX/Buzz.mp3");
  breakSFX = audio.loadSound("SFX/Break.mp3");
  stepSFX = audio.loadSound("SFX/Step.mp3");
  _G.finalScore = nil;
  currentMode = _G.activeMode;
  
	local group = scene.view;
  adsLib.showBannerAd("bottom");
  
  for i = 1, 10 do
    createShoes(group, 1);
  end
  for i = 1, 10 do
    createShoes(group, 2);
  end
  
  gameLayer = display.newGroup();
  gameLayer.newPosition = 0;
  group:insert(gameLayer);
  
  createTiles(gameLayer);
  
  hudLayer = display.newGroup();
  group:insert(hudLayer);
  createHud(hudLayer);
  
  createTutorial(group);
  
  function gameLayer:enterFrame()
    local FPS = fpsLib.FPS;
    if self.newPosition > 0 and not self.gameOver then
      self.newPosition = self.newPosition-scrollSpeed*FPS;
      self.y = self.y+scrollSpeed*FPS;
    elseif self.gameOver then
      self.time = (self.time or 0)+1*FPS;
      if self.time >= delayBeforeShowingGameOver then
        storyboard.gotoScene("gameOverScene", "fade");
--         adsLib.showFullscreenOnFinish("revmob");
--         adsLib.showFullscreenOnFinish("playhaven");
      end
    end
  end
  Runtime:addEventListener("enterFrame", gameLayer);
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
  
  audio.stop();
  audio.dispose(beepSFX);
  audio.dispose(buzzSFX);
  audio.dispose(breakSFX);
  audio.dispose(stepSFX);
  beepSFX = nil;
  buzzSFX = nil;
  breakSFX = nil;
  stepSFX = nil;
  
  tilesSheet = nil;
  activeRowTile = nil;
  startTime = nil;
	
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