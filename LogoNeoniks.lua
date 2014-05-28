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


local centerX = display.contentCenterX;
local centerY = display.contentCenterY;  

function scene:createScene( event )
	local group = scene.view;
        local bg = display.newImageRect(group, help.localizableImage("logoA"), 250, 191);
        bg.x, bg.y = centerX, centerY;
        bg.alpha = 0;
  
  transition.to( bg, { delay = timeInterval, time=timeInterval, alpha = 1, 
  	onComplete = function()
  		transition.to( bg, { delay = timeInterval, time=timeInterval, alpha = 0, 
  	onComplete = function()
  		storyboard.gotoScene("menuScene", "fade");
--         adsLib.showFullscreenAd("revmob");
--         adsLib.showFullscreenAd("chartboost");
--         adsLib.showFullscreenAd("vungle");
--         adsLib.showFullscreenAd("playhaven");
  		end })
  	end })
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