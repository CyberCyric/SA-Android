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

local function arrowRightHandler( event )
    composer.gotoScene('screen-help02') 
end

 
 function gotoMenu()
  Runtime:removeEventListener( "key", globalEventListener )
  composer.gotoScene('screen-menu')
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

     local arrowRight = display.newImage(sceneGroup, "Images/arrowRight.png" )
     arrowRight.anchorX = 0
     arrowRight.anchorY  = 0
     arrowRight.x = rightSide - 55
     arrowRight.y = topSide + 28
     arrowRight.height = 15
     arrowRight.width = 15
     arrowRight:addEventListener("tap", arrowRightHandler)     

    texto1 = display.newText(sceneGroup, "Sucesos Argentinos es un juego de cartas dónde se pone a prueba tu conocimiento de historia argentina.", 0,0, totalWidth  - 80, 100, "fonts\\georgia.ttf", 20 )
    texto1:setFillColor( 1, 1, 1 )
    texto1.anchorX = 0
    texto1.x = leftSide + 50
    texto1.y = topSide + 120

    texto2 = display.newText(sceneGroup, "La idea es simple: \n Tenés que construir una línea de tiempo colocando las cartas en el orden correcto en que ocurrieron los eventos. ", 0, 0, 250, 100, "fonts\\georgia.ttf", 14 )
    texto2.anchorX = 0
    texto2:setFillColor( 1, 1, 1 )  
    texto2.x = leftSide + 320
    texto2.y = topSide + 280

    local linea = display.newImage(sceneGroup, "Images/linea.png" )
    linea.anchorX = 0
    linea.anchorY  = 0
    linea.x = leftSide + 70
    linea.y = topSide + 100
    linea.width = 380
    linea.height = 220

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