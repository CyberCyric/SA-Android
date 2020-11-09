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
    composer.gotoScene('screen-help07') 
end

local function arrowRightHandler( event )
    composer.gotoScene('screen-help09') 
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
    local backgroundImage = display.newImage(sceneGroup, "Images/background.jpg" )
    backgroundImage.anchorX = 0.5
    backgroundImage.anchorY = 0.5
    backgroundImage.x = centerX
    backgroundImage.y = centerY
    backgroundImage.height = totalHeight
    backgroundImage.width = totalWidth  

    local logoImage = display.newImage(sceneGroup, "Images/logoSA-lg.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = 10
    logoImage.y = 10
    utils.fitImage(logoImage, 200 , 133 , false)   
    logoImage:addEventListener("tap", gotoMenu)

     lbOpciones = display.newImageRect(sceneGroup, "Images/lbAyuda.png", 380,  50 )
     utils.fitImage(lbOpciones, 200, 90, false)
     lbOpciones.anchorX = 1
     lbOpciones.anchorY = 0
     lbOpciones.x = rightSide - 20
     lbOpciones.y = topSide + 20      

    texto1 = display.newText(sceneGroup, "Opciones", rightSide - 250, 120, 250, 100, "georgia.ttf", 24 )
    texto1.anchorX = 0
    texto1:setFillColor( 1, 1, 1 )
    texto3 = display.newText(sceneGroup, "Las opciones del juego permiten elegir si se juega con o sin sonido y si es necesario tocar una o dos veces los círculos en la línea de tiempo para colocar la carta, para reconfirmar la posición.", leftSide + 160, topSide + 280, 350, 200, "georgia.ttf", 11 )
    texto3.anchorX = 0
    texto3:setFillColor( 1, 1, 1 )

    local imgOpciones = display.newImage(sceneGroup, "Images/opciones.png" )
    imgOpciones.anchorX = 0
    imgOpciones.anchorY  = 0
    imgOpciones.x = leftSide + 50
    imgOpciones.y = topSide + 140
    utils.fitImage(imgOpciones, 280 , 120 , false)    

    local arrowRight = display.newImage(sceneGroup, "Images/arrowRight.png" )
    arrowRight.anchorX = 0
    arrowRight.anchorY  = 0
    arrowRight.x = rightSide - 45
    arrowRight.y = bottomSide - 45
    utils.fitImage(arrowRight, 40 , 40 , false)   
    arrowRight:addEventListener("tap", arrowRightHandler)

    local arrowLeft = display.newImage(sceneGroup, "Images/arrowLeft.png" )
    arrowLeft.anchorX = 0
    arrowLeft.anchorY  = 0
    arrowLeft.x = leftSide + 5
    arrowLeft.y = bottomSide - 45
    utils.fitImage(arrowLeft, 40 , 40 , false)   
    arrowLeft:addEventListener("tap", arrowLeftHandler)      

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