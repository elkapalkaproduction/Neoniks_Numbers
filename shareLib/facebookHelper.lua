local facebook = require "facebook";
local json = require "json";
local facebookHelper = {};
local appID = _G.facebookAPPID;

facebookHelper.postOnUserWall = function(message)
  native.setActivityIndicator(true);
  local listener;
  listener = function(event)
	  if ( "session" == event.type ) then
		  if ( "login" == event.phase ) then
        local postMsg = {
          message = message,
          picture = "http://ragdogstudios.com/wp-content/uploads/2014/02/flappy_thumb.png",
          description = "Get the Flappy Bird Template for Corona SDK and learn how to make one of the biggest hits currently on the stores!",
          link = "http://bit.ly/1eDPypU",
          name = "Flappy Bird Template",
          caption = "Flappy Bird Template for Corona SDK!"
        };
        facebook.request( "me/feed", "POST", postMsg )
        native.setActivityIndicator(true);
		  end
	  elseif ("request" == event.type) then	
			local respTab = json.decode(event.response);
      native.setActivityIndicator(false);
   		if respTab then
         native.showAlert("Success", "Message successfuly posted!", {"OK"});
			end
		end
    native.setActivityIndicator(nil);
	end
  facebook.login(appID, listener, {"publish_actions"});
end

return facebookHelper;