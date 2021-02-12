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
    if (id == "ranking") then
        composer.gotoScene('screen-leaderboards')
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
    if (id == 'AAL') then
        system.openURL( "http://www.aaludica.com.ar" ) 
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
    utils.fitImage(backgroundImage, totalWidth, totalHeight, false)

    local logoImage = display.newImage(sceneGroup, "Images/sa_logo.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = leftSide+27
    logoImage.y = topSide+12.5
    logoImage.width = 142.5
    logoImage.height = 95

    local logoAAImage = display.newImage(sceneGroup, "Images/aa_logo_sm.png" )
    logoAAImage.anchorX = 0
    logoAAImage.anchorY  = 0
    logoAAImage.x = utils.perc( 80, display.contentWidth)
    logoAAImage.y = utils.perc( 55, display.contentHeight)
    logoAAImage.width = 67.5
    logoAAImage.height = 53

    local txtMenu = display.newText( "Sucesos Argentinos es un juego de cartas donde se pone a prueba tu conocimiento, organizando una cadena en orden cronológico con varios hitos de la historia argentina. \n\n En esta versión digital podés autodesafiarte a armar la línea de tiempo más extensa que puedas.", 
        220, 20, totalWidth / 2, 200, "fonts\\georgia.ttf", 12 )
    txtMenu:setFillColor( 1, 1, 1 )
    txtMenu.anchorX = 0
    txtMenu.anchorY = 0
    sceneGroup:insert( txtMenu )  

    local cartas = display.newImage(sceneGroup, "Images/sa_volumenes.png" )
    cartas.anchorX = 0
    cartas.anchorY  = 0
    cartas.x = 200
    cartas.y = 150  
    cartas.width = 242
    cartas.height = 161

    local txtAALudicaOptions = 
    {
        text = "Podés conseguir la versión de mesa y nuestros otros juegos en:", 
        x = 395, 
        y = 250, 
        width = 110, 
        height = 200, 
        font = "fonts\\georgia.ttf", 
        fontSize = 10, 
        align = "right"
    }
    local txtAALudica = display.newText( txtAALudicaOptions )
    txtAALudica:setFillColor( 1, 1, 1 )
    txtAALudica.anchorX = 0
    txtAALudica.anchorY = 0
    sceneGroup:insert( txtAALudica )     

-- Main Menu
    local butShowGameModes = widget.newButton({ 
        id = "startGame",
        width = 100,
        height = 33,
        defaultFile = "Images/btn_jugar.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butShowGameModes.x = leftSide+50
    butShowGameModes.y = 122.5
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
    butCartas.x = leftSide+50
    butCartas.y = 166
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
    butOptions.x = leftSide+50
    butOptions.y = 208
    butOptions.anchorX = 0
    butOptions.anchorY = 0
    sceneGroup:insert( butOptions )

    local butHelp = widget.newButton({   
        id = "ayuda", 
        width = 24,
        height = 24,        
        defaultFile = "Images/btn_ayuda.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butHelp.x = leftSide + 90
    butHelp.y = 260
    butHelp.anchorX = 0
    butHelp.anchorY = 0
    butHelp.isVisible = true
    sceneGroup:insert( butHelp )    

    local butAAL = widget.newButton({   
        id = "AAL", 
        width = 150,
        height = 32,
        defaultFile = "Images/btn_visitanos.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butAAL.x = rightSide - 160
    butAAL.y = bottomSide - 35
    butAAL.anchorX = 0
    butAAL.anchorY = 0
    sceneGroup:insert( butAAL )
 
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