local composer = require( "composer" )
local utils = require( "utils" )
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
 
 -- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function handleButtonEvent( event )
    local id = event.target.id
    if (id == "startGame") then
        local options = {
            effect = "fade",
            time = 500,
            isModal = true
        }
        composer.showOverlay( "screen-gameModes", options )
    end
    if (id == "gameOptions") then
        composer.gotoScene('screen-options')
    end
    if (id == "album") then
        composer.gotoScene('screen-album')
    end
    if (id == "ayuda") then
        composer.gotoScene('screen-help01')
    end
    
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    composer.removeScene( "screen-game" )
    Runtime:removeEventListener( "key", globalEventListener )

    -- Code here runs when the scene is first created but has not yet appeared on screen
    local backgroundImage = display.newImage(sceneGroup, "Images/background.png" )
    backgroundImage.anchorX = 0
    backgroundImage.anchorY = 0
    backgroundImage.x = leftSide
    backgroundImage.y = topSide
    backgroundImage.width = totalWidth
    backgroundImage.height = totalHeight

    local logoImage = display.newImage(sceneGroup, "Images/sa_logo.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = leftSide+70
    logoImage.y = topSide+12.5
    logoImage.width = 180
    logoImage.height = 100

    local logoAAImage = display.newImage(sceneGroup, "Images/aa_logo_sm.png" )
    logoAAImage.anchorX = 0
    logoAAImage.anchorY  = 0
    logoAAImage.x = rightSide - 70
    logoAAImage.y = bottomSide - 35
    logoAAImage.width = 35
    logoAAImage.height = 28

    local txtMenu = display.newText( "Sucesos Argentinos es un juego de cartas donde se pone a prueba tu conocimiento, organizando una cadena en orden cronológico con varios hitos de la historia argentina. \n\n En esta versión digital podés autodesafiarte a armar la línea de tiempo más extensa que puedas.", 
        220, 20, totalWidth / 2, 200, "fonts\\georgia.ttf", 14 )
    txtMenu:setFillColor( 1, 1, 1 )
    txtMenu.x = utils.pixToWidth( 820 )
    txtMenu.y = utils.pixToHeight( 100 )
    txtMenu.anchorX = 0
    txtMenu.anchorY = 0
    sceneGroup:insert( txtMenu )  

    local volumenes = display.newImage(sceneGroup, "Images/sa_volumenes.png" )
    volumenes.anchorX = 0
    volumenes.anchorY  = 0
    volumenes.x = 150
    volumenes.y = topSide + 150
    volumenes.width = 270
    volumenes.height = 180 

    local linea = display.newImage(sceneGroup, "Images/linea.png" )
    linea.anchorX = 0
    linea.anchorY  = 0
    linea.x = leftSide + 450
    linea.y = topSide + 190
    linea.width = 230
    linea.height = 132

-- Main Menu
    local butShowGameModes = widget.newButton({ 
        id = "startGame",
        width = 120,
        height = 40,
        defaultFile = "Images/btn_jugar.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butShowGameModes.x = leftSide + 90
    butShowGameModes.y = utils.pixToHeight(490)
    butShowGameModes.anchorX = 0
    butShowGameModes.anchorY = 0
    sceneGroup:insert( butShowGameModes )

 local butCartas = widget.newButton({  
        id = "album",  
        width = 100,
        height = 33,
        defaultFile = "Images/btn_cartas.png",
        onEvent = handleButtonEvent
    })
    -- Center the button
    butCartas.x = leftSide + 100
    butCartas.y = 200
    butCartas.anchorX = 0
    butCartas.anchorY = 0
    sceneGroup:insert( butCartas )

    local butOptions = widget.newButton({   
        id = "gameOptions", 
        width = 100,
        height = 33,
        defaultFile = "Images/btn_opciones.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butOptions.x =  leftSide + 100
    butOptions.y = 240
    butOptions.anchorX = 0
    butOptions.anchorY = 0
    sceneGroup:insert( butOptions )

    local butHelp = widget.newButton({   
        id = "ayuda", 
        width = 32,
        height = 32,        
        defaultFile = "Images/btn_ayuda.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butHelp.x = leftSide + 135
    butHelp.y = 280
    butHelp.anchorX = 0
    butHelp.anchorY = 0
    butHelp.isVisible = true
    sceneGroup:insert( butHelp )    
 
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