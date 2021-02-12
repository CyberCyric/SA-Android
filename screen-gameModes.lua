local composer = require( "composer" )
local widget = require( "widget" )

local leftSide = display.screenOriginX;
local rightSide = display.contentWidth-display.screenOriginX;
local topSide = display.screenOriginY;
local bottomSide = display.contentHeight-display.screenOriginY;
local totalWidth = display.contentWidth-(display.screenOriginX*2);
local totalHeight = display.contentHeight-(display.screenOriginY*2);
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
local function handleButtonEvent( event )

    if ( event.target.id == 'butStartTimedGame') then
        composer.setVariable("isRankedGame", true)
    else
        composer.setVariable("isRankedGame", false)
    end

     composer.gotoScene('screen-game')
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local backgroundImage = display.newImage(sceneGroup, "Images/background_light.png" )
    backgroundImage.anchorX = 0.5
    backgroundImage.anchorY = 0.5
    backgroundImage.x = centerX
    backgroundImage.y = centerY
    backgroundImage.height = totalHeight - 100
    backgroundImage.width = totalWidth - 100

    local separador = display.newImage(sceneGroup, "Images/separador_v.png")
    separador.anchorX = 0.5
    separador.anchorY = 0.5
    separador.x = centerX
    separador.y = centerY
    separador.height = backgroundImage.height * 0.8
    separador.width = 5

    local butStartCasualGame = widget.newButton({ 
        id = "startCasualGame",
        defaultFile = "Images/btn_modo_casual.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butStartCasualGame.x = backgroundImage.width / 4
    butStartCasualGame.y = backgroundImage.y 
    butStartCasualGame.anchorX = 0.5
    butStartCasualGame.anchorY = 0.5
    butStartCasualGame.width = 160
    butStartCasualGame.height = 122
    sceneGroup:insert( butStartCasualGame )

    local butStartTimedGame = widget.newButton({ 
        id = "startTimedGame",
        defaultFile = "Images/btn_modo_reloj.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butStartTimedGame.x = backgroundImage.width * 3 / 4
    butStartTimedGame.y = backgroundImage.y 
    butStartTimedGame.anchorX = 0.5
    butStartTimedGame.anchorY = 0.5
    butStartTimedGame.width = 160
    butStartTimedGame.height = 122
    sceneGroup:insert( butStartTimedGame )
 
 end
 
 -- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene