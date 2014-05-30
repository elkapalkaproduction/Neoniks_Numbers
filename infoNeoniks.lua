----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local widget = require("widget")
local ragdogLib = require "ragdogLib";
local networksLib = require "networksLib";
local fpsLib = require "fpsLib";
local timeInterval = 1000;

local adsLib = require "adsLib";

local totalWidth = _G.totalWidth;
local totalHeight = _G.totalHeight;
local leftSide = _G.leftSide;
local rightSide = _G.rightSide;
local topSide = _G.topSide;
local bottomSide = _G.bottomSide;
local centerX = display.contentCenterX;
local centerY = display.contentCenterY; 

local help = require "help";


function scene:createScene( event )
	local group = scene.view;
  local scrollView = widget.newScrollView {
  left = leftSide,
  top = topSide,
  width = totalWidth,
  height = totalHeight,
  horizontalScrollDisabled = true,
  verticalScrollDisabled = false,
  scrollWidth = 8 * totalWidth / 3,
  backgroundColor = { 0, 0, 0 },
  friction = 0.5,
}
 local bg = display.newImageRect(group, help.imagePath("background_about_us"), help.sizes(384, 1024));
  bg.x, bg.y = totalWidth / 2, 4 * totalWidth / 3;
  local bgText = display.newImageRect(group, help.localizableImage("about_us_text"), help.sizes(384, 1024));
  bgText.x, bgText.y = totalWidth / 2, bg.y;
  local coeficient = totalWidth / 384;
   local playButton = ragdogLib.newSimpleButton(group, help.localizableImage("play"), help.sizes(110,38));
  playButton.x, playButton.y = (37 / 192) * totalWidth, 19 * totalWidth / 8 - 50;
  function playButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function playButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    storyboard.gotoScene("menuScene", "fade");
    scrollView:removeSelf();
  end

    local moreButton = ragdogLib.newSimpleButton(group, help.localizableImage("more"), help.sizes(110,38));
  moreButton.x, moreButton.y = playButton.x, playButton.y - playButton.height*1.5;
  function moreButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function moreButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    adsLib.showFullscreenOnFinish("chartboost");

  end

  local neoniksButton = ragdogLib.newSimpleButton(group, help.localizableImage("www"), help.sizes(198, 48));
  neoniksButton.x, neoniksButton.y = totalWidth / 2, 1.20* totalWidth;
  function neoniksButton:touchBegan()
    self:setFillColor(.5, .5, .5);
    self.xScale, self.yScale = .9, .9;
  end
  function neoniksButton:touchEnded()
    audio.play(buttonSFX, {channel = audio.findFreeChannel()});
    self:setFillColor(1, 1, 1);
    self.xScale, self.yScale = 1, 1;
    system.openURL( help.getSite() );

  end
  scrollView:insert(bg);
  scrollView:insert(bgText);
  scrollView:insert(playButton);
  scrollView:insert(moreButton);
  scrollView:insert(neoniksButton);
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