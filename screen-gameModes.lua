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

    if ( event.target.id == 'startRankedGame') then
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

    local backgroundImage = display.newImage(sceneGroup, "Images/box.png" )
    backgroundImage.anchorX = 0.5
    backgroundImage.anchorY = 0.5
    backgroundImage.x = centerX
    backgroundImage.y = centerY
    backgroundImage.height = totalHeight - 100
    backgroundImage.width = totalWidth - 100

    local lbModoJuego = display.newText(" Elegí el modo de juego:", leftSide + 250, 100, 350, 0, "FjallaOne-Regular", 22 )
    lbModoJuego:setFillColor( 0, 0, 0 ) 
    sceneGroup:insert( lbModoJuego )   

    local butStartCasualGame = widget.newButton({ 
        id = "startCasualGame",
        width = 150,
        height = 40,
        label = "Casual",
        font = "FjallaOne-Regular",
        fontSize = 24,
        onRelease = handleButtonEvent
    })
    -- Center the button
    butStartCasualGame.x = leftSide+140
    butStartCasualGame.y = 130
    butStartCasualGame.anchorX = 0.5
    butStartCasualGame.anchorY = 0
    sceneGroup:insert( butStartCasualGame )

    local txtCasualGame = display.newText( "Tranquilo. Relajado. Sin presiones.", leftSide + 220, 140, 350, 0, "georgia.ttf", 16 )
    txtCasualGame.anchorX = 0
    txtCasualGame.anchorY = 0
    txtCasualGame:setFillColor( 0.2, 0.2, 0.2 )
    sceneGroup:insert( txtCasualGame )

    local butStartRankedGame = widget.newButton({ 
        id = "startRankedGame",
        width = 150,
        height = 40,
        label = "Contra reloj",
        font = "FjallaOne-Regular",
        fontSize = 24,        
        onRelease = handleButtonEvent
    })
    -- Center the button
    butStartRankedGame.x = leftSide+140
    butStartRankedGame.y = 190
    butStartRankedGame.anchorX = 0.5
    butStartRankedGame.anchorY = 0
    sceneGroup:insert( butStartRankedGame )

    local txtRankedGame = display.newText( "¡Tenés 15 segundos para ubicar cada carta! Los mejores resultados van al Ranking global.", leftSide + 220, 190, 300, 0, "georgia.ttf", 16 )
    txtRankedGame.anchorX = 0
    txtRankedGame.anchorY = 0
    txtRankedGame:setFillColor( 0.2, 0.2, 0.2 )
    sceneGroup:insert( txtRankedGame )
 
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