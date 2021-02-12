-----------------------------------------------------------------------------------------
local migrate = require( "migrate" )

local composer = require( "composer" )
local utils = require( "utils" )
local scene = composer.newScene()

local leftSide = display.screenOriginX;
local rightSide = display.contentWidth-display.screenOriginX;
local topSide = display.screenOriginY;
local bottomSide = display.contentHeight-display.screenOriginY;
local totalWidth = display.contentWidth-(display.screenOriginX*2);
local totalHeight = display.contentHeight-(display.screenOriginY*2);
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    local fondoBlanco = display.newRect( leftSide, topSide, totalWidth, totalHeight )
    fondoBlanco.anchorX = 0
    fondoBlanco.anchorY = 0
    sceneGroup:insert( fondoBlanco )
    local logoAAImage = display.newImage( "Images/aa_full_logo.jpg" )
    logoAAImage.x = display.contentWidth / 2
    logoAAImage.y = display.contentHeight / 2
    utils.fitImage(logoAAImage, display.contentWidth, display.contentHeight, false)
    sceneGroup:insert( logoAAImage )
    local txtActualizando = display.newText( "Juegos educativos",  centerX, centerY + 70, "fonts\\FjallaOne-Regular.ttf", 14 )
    txtActualizando:setFillColor( 0, 0, 0 )
    sceneGroup:insert( txtActualizando )

end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        migrate.doMigrate()
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        timer.performWithDelay(1000, function() composer.gotoScene("screen-menu"); end)

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