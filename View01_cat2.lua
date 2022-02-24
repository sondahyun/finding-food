-----------------------------------------------------------------------------------------
--
-- view1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

function scene:create( event )
	local sceneGroup = self.view
	local ff=0

	local explosionSound = audio.loadSound( "Content/PNG/cat/계곡물.mp3" )
	audio.play( explosionSound )

	local function makefish()
		local background = display.newImageRect("Content/PNG/cat/배경.png", display.contentWidth, display.contentHeight)
		background.x, background.y = display.contentWidth/2, display.contentHeight/2

		local howtoplay=display.newText("제한시간안에 클릭하여 물고기를 잡으세요!",display.contentCenterX,display.contentWidth*0.1)
		howtoplay.size=50

		local fish = { }
		local fishGroup=display.newGroup() 

		for i=1,12 do
			if i%2==0 then
				fish[i] = display.newImage(fishGroup,"Content/PNG/cat/물고기2.png")
			else
				fish[i] = display.newImage(fishGroup,"Content/PNG/cat/물고기1.png")
			end
			fish[i].x,fish[i].y= background.x + math.random(-450, 350),background.y + math.random(100, 780)
		end

		sceneGroup:insert(fishGroup)
		--스코어 출력--
		local score=0
		local print= display.newText("얻은 점수:",display.contentWidth*0.75,display.contentHeight*0.15)
		print:setFillColor(0)
		print.size = 70
		local showScore = display.newText("",display.contentWidth*0.9,display.contentHeight*0.15)
		showScore:setFillColor(0)
		showScore.size=70

		
			--레이어 정리--
		sceneGroup:insert(background)
		sceneGroup:insert(fishGroup)
		
		sceneGroup:insert(showScore)
		sceneGroup:insert(howtoplay)
		
		sceneGroup:insert(print)
		

		fishGroup:toFront()

		--탭 이벤트--
		local function catch(event)
			display.remove(event.target)
			score=score+1
			showScore.text=score

			if score==12 then
				composer.setVariable("complete",true)
				ff=2
				composer.removeScene("View01_cat")
				composer.gotoScene("View02_cat")
			end
		end
		
		for i=1,12 do
			fish[i]:addEventListener("tap",catch)
		end
		
		-- 시간 제한 --

		local result = composer.getVariable("flag")


		local limit=10
		local print3= display.newText("남은 시간:",display.contentWidth*0.75,display.contentHeight*0.1)
		print3:setFillColor(0)
		print3.size = 70
		local showLimit = display.newText("",display.contentWidth*0.9,display.contentHeight*0.1)
		showLimit:setFillColor(0)
		showLimit.size = 70
		sceneGroup:insert(showLimit)
		sceneGroup:insert(print3)

		local function timeAttack(event)
			limit = limit - 1
			showLimit.text=limit

			if limit == 0 then
				composer.setVariable("complete",false)
				makefish()
				composer.gotoScene("View02_cat")
			end
		end

		timer.performWithDelay(1000,timeAttack,0)
	end
	
	if ff==0 then
		makefish()
	end
	
	

	
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