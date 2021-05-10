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
    composer.gotoScene('screen-help02') 
end

local function arrowRightHandler( event )
    composer.gotoScene('screen-help04') 
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

     lbOpciones = display.newImageRect(sceneGroup, "Images/lbAyuda.png", 60,  27 )
     lbOpciones.anchorX = 0.5
     lbOpciones.anchorY = 0
     lbOpciones.x = leftSide + 120
     lbOpciones.y = topSide + 20   
     
     local arrowLeft = display.newImage(sceneGroup, "Images/arrowLeft.png" )
     arrowLeft.anchorX = 0
     arrowLeft.anchorY  = 0
     arrowLeft.x = rightSide - 85
     arrowLeft.y = topSide + 28
     arrowLeft.height = 15
     arrowLeft.width = 15
     arrowLeft:addEventListener("tap", arrowLeftHandler)   
     
     local arrowRight = display.newImage(sceneGroup, "Images/arrowRight.png" )
     arrowRight.anchorX = 0
     arrowRight.anchorY  = 0
     arrowRight.x = rightSide - 55
     arrowRight.y = topSide + 28
     arrowRight.height = 15
     arrowRight.width = 15
     arrowRight:addEventListener("tap", arrowRightHandler)      

     texto1 = display.newText(sceneGroup, "Las cartas", 0, 0, 600, 100, "fonts\\georgia.ttf", 24 )
     texto1.x = leftSide + 50
     texto1.y = topSide + 120
     texto1.anchorX = 0
     texto1:setFillColor( 1, 1, 1 )
 
     texto2 = display.newText(sceneGroup, "Esta versión digital incluye las mismas cartas que están publicadas en los Volúmenes 1 ('Gobiernos y Conflictos'), 2 ('Economía y Sociedad'), 3 ('Ciencia y Cultura') y 4 ('Cambalache') del juego de mesa Sucesos Argentinos.", 0, 0, totalWidth - 80, 100, "fonts\\georgia.ttf", 12 )
     texto2.anchorX = 0    
     texto2.anchorY  = 0
     texto2.x = leftSide + 50
     texto2.y = topSide + 120
     texto2:setFillColor( 1, 1, 1 )

     texto3 = display.newText(sceneGroup, "Además, se incluye un conjunto de Cartas Inéditas, exclusivas para esta app. ¡Pero no es tán fácil! Todas las Cartas Inéditas comienzan bloqueadas.\n\n Cada vez que terminas una partida, hay una chance de que puedas desbloquear una Carta Inédita al azar, que se va a agregar a tu colección. Cuanto más larga es la línea de tiempo que conseguís armar, más chances tenés de desbloquear una Carta Inédita.", 0, 0, totalWidth - 80, 100, "fonts\\georgia.ttf", 12 )
     texto3.anchorX = 0    
     texto3.anchorY  = 0
     texto3.x = leftSide + 50
     texto3.y = topSide + 200
     texto3:setFillColor( 1, 1, 1 )

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