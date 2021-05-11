local composer = require( "composer" )
local widget = require( "widget" )
local utils = require( "utils" )

local leftSide = display.screenOriginX;
local rightSide = display.contentWidth-display.screenOriginX;
local topSide = display.screenOriginY;
local bottomSide = display.contentHeight-display.screenOriginY;
local totalWidth = display.contentWidth-(display.screenOriginX*2);
local totalHeight = display.contentHeight-(display.screenOriginY*2);
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

local globalEventListener

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 local function arrowLeftHandler( event )
    composer.gotoScene('screen-help03') 
end

 function gotoMenu()
  Runtime:removeEventListener( "key", globalEventListener )
  composer.gotoScene('screen-menu')
end

local function openAASite( event )  
    system.openURL( "http://www.aaludica.com.ar" ) 
end

globalEventListener = function( event )
    if ( event.keyName == "back" ) then       
        if (event.phase == "up") then
          Runtime:removeEventListener( "key", globalEventListener )
          gotoMenu()
          return true
        end
    end        
end
Runtime:addEventListener( "key", globalEventListener )
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event ) 
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    composer.removeScene( "screen-menu" )
    local backgroundImage = display.newImage(sceneGroup, "Images/background.png" )
    backgroundImage.anchorX = 0.5
    backgroundImage.anchorY = 0.5
    backgroundImage.x = centerX
    backgroundImage.y = centerY
    backgroundImage.height = totalHeight
    backgroundImage.width = totalWidth  

    local logoImage = display.newImage(sceneGroup, "Images/sa_logo_small.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = leftSide + 30
    logoImage.y = topSide + 10
    logoImage.height = 50
    logoImage.width = 50
    logoImage:addEventListener("tap", gotoMenu)

    local logoAAImage = display.newImage(sceneGroup, "Images/aa_logo_sm.png" )
    logoAAImage.anchorX = 0
    logoAAImage.anchorY  = 0
    logoAAImage.x = rightSide - 70
    logoAAImage.y = bottomSide - 35
    logoAAImage.width = 35
    logoAAImage.height = 28

    lbOpciones = display.newImageRect(sceneGroup, "Images/lbAyuda.png", 150,  23 )
    lbOpciones.anchorX = 0.5
    lbOpciones.anchorY = 0
    lbOpciones.x = leftSide + 160
    lbOpciones.y = topSide + 20   
     
     local arrowLeft = display.newImage(sceneGroup, "Images/arrowLeft.png" )
     arrowLeft.anchorX = 0
     arrowLeft.anchorY  = 0
     arrowLeft.x = rightSide - 85
     arrowLeft.y = topSide + 28
     arrowLeft.height = 15
     arrowLeft.width = 15
     arrowLeft:addEventListener("tap", arrowLeftHandler)      

     texto1 = display.newText( sceneGroup,"Contacto", rightSide - 250, 120, 250, 100, "fonts\\georgia.ttf", 24 )
     texto1.anchorX = 0
     texto1:setFillColor( 1, 1, 1 )
 
     lbPodesContactarnos = display.newImageRect(sceneGroup, "Images/podes_contactarnos.png", 300,  16 )
     utils.fitImage(lbPodesContactarnos, 300, 16, false)
     lbPodesContactarnos.anchorX = 0
     lbPodesContactarnos.anchorY = 0
     lbPodesContactarnos.x = leftSide + 50
     lbPodesContactarnos.y = topSide + 170 
 
     lbAdemasPodes = display.newImageRect(sceneGroup, "Images/ademas_podes.png", 470,  13 )
     utils.fitImage(lbAdemasPodes, 470, 13, false)
     lbAdemasPodes.anchorX = 0
     lbAdemasPodes.anchorY = 0
     lbAdemasPodes.x = leftSide + 50
     lbAdemasPodes.y = topSide + 200
     lbAdemasPodes:addEventListener("tap", openAASite)

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