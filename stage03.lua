-----------------------------------------------------------------------------------------
--
-- View01_bear.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	
	local background = display.newImageRect("Content/PNG/stage/스테이지3.png", display.contentWidth, display.contentHeight)
	background.x, background.y=display.contentWidth/2, display.contentHeight/2

	local hed= display.newImageRect("Content/PNG/stage/스테이지3고슴도치.png", 200, 250)
	hed.x, hed.y = display.contentWidth*0.73, display.contentHeight*0.7
	hed.alpha=0.3
	local bear = display.newImageRect("Content/PNG/stage/스테이지3곰.png", 200, 350)
	bear.x, bear.y = display.contentWidth*0.3, display.contentHeight*0.35

	if (composer.getVariable("bear")) then
		hed.alpha=1
	end

	local arrowleft = display.newImageRect("Content/PNG/stage/왼쪽넘기기.png",80, 80)
	arrowleft.x, arrowleft.y = display.contentWidth*0.1, display.contentHeight/2
	
	local arrowright = display.newImageRect("Content/PNG/stage/오른쪽넘기기.png",80, 80)
	arrowright.x, arrowright.y = display.contentWidth*0.9, display.contentHeight/2

	local function beforemove()
		composer.gotoScene("stage02")
	end

	local function nextmove()
		composer.gotoScene("stage04")
	end

	arrowleft:addEventListener("tap", beforemove)
	arrowright:addEventListener("tap", nextmove)

	sceneGroup:insert(background)
	sceneGroup:insert(hed)
	sceneGroup:insert(bear)
	sceneGroup:insert(arrowright)
	sceneGroup:insert(arrowleft)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene