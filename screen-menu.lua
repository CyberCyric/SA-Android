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
    local backgroundImage = display.newImage(sceneGroup, "Images/background.jpg" )
    backgroundImage.anchorX = 0
    backgroundImage.anchorY = 0
    backgroundImage.x = leftSide
    backgroundImage.y = topSide
    --utils.fitImage(backgroundImage, display.contentWidth /2, display.contentHeight /2, false)

    local logoImage = display.newImage(sceneGroup, "Images/logoSA-lg.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = leftSide+10
    logoImage.y = topSide+10
    utils.fitImage(logoImage, 200 , 133 , false)

    local txtMenu = display.newText( "Sucesos Argentinos es un juego de cartas donde se pone a prueba tu conocimiento, organizando una cadena en orden cronológico con varios hitos de la historia argentina. \n\n En esta versión digital podés autodesafiarte a armar la línea de tiempo más extensa que puedas.", 
        220, 20, totalWidth / 2, 200, "georgia.ttf", 12 )
    txtMenu:setFillColor( 1, 1, 1 )
    txtMenu.anchorX = 0
    txtMenu.anchorY = 0
    sceneGroup:insert( txtMenu )  

    local cartas = display.newImage(sceneGroup, "Images/cartas.png" )
    cartas.anchorX = 0
    cartas.anchorY  = 0
    cartas.x = leftSide + 240
    cartas.y = topSide + 170
    utils.fitImage(cartas, 170 , 150 , false)    

    local cajaSucesos = display.newImage(sceneGroup, "Images/caja-sucesos.png" )
    cajaSucesos.anchorX = 0
    cajaSucesos.anchorY  = 0
    cajaSucesos.x = rightSide - 180
    cajaSucesos.y = topSide + 140
    utils.fitImage(cajaSucesos, 280 , 120 , false)

    local txtAALudicaOptions = 
    {
        text = "Podés conseguir la versión de mesa y nuestros otros juegos en:", 
        x = 395, 
        y = 250, 
        width = 110, 
        height = 200, 
        font = "georgia.ttf", 
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
        width = 140,
        height = 50,
        defaultFile = "Images/boton-jugar.png",
        overFile = "Images/boton-jugar-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butShowGameModes.x = leftSide+50
    butShowGameModes.y = 110
    butShowGameModes.anchorX = 0
    butShowGameModes.anchorY = 0
    sceneGroup:insert( butShowGameModes )

    local butRanking = widget.newButton({  
        id = "ranking",  
        width = 140,
        height = 50,
        defaultFile = "Images/boton-ranking.png",
        overFile = "Images/boton-ranking-on.png",
        onEvent = handleButtonEvent
    })
    -- Center the button
    butRanking.x = leftSide+50
    butRanking.y = 160
    butRanking.anchorX = 0
    butRanking.anchorY = 0
    sceneGroup:insert( butRanking )

 local butCartas = widget.newButton({  
        id = "album",  
        width = 140,
        height = 50,
        defaultFile = "Images/boton-album.png",
        overFile = "Images/boton-album-on.png",
        onEvent = handleButtonEvent
    })
    -- Center the button
    butCartas.x = leftSide+50
    butCartas.y = 210
    butCartas.anchorX = 0
    butCartas.anchorY = 0
    sceneGroup:insert( butCartas )

    local butOptions = widget.newButton({   
        id = "gameOptions", 
        width = 45,
        height = 39,
        defaultFile = "Images/boton-opciones.png",
        overFile = "Images/boton-opciones-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butOptions.x = leftSide+60
    butOptions.y = 270
    butOptions.anchorX = 0
    butOptions.anchorY = 0
    sceneGroup:insert( butOptions )

    local butHelp = widget.newButton({   
        id = "ayuda", 
        width = 45,
        height = 39,        
        defaultFile = "Images/boton-ayuda.png",
        overFile = "Images/boton-ayuda-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butHelp.x = leftSide+130
    butHelp.y = 270
    butHelp.anchorX = 0
    butHelp.anchorY = 0
    butHelp.isVisible = true
    sceneGroup:insert( butHelp )    

    local butAAL = widget.newButton({   
        id = "AAL", 
        width = 150,
        height = 32,
        defaultFile = "Images/boton-aaludica.png",
        overFile = "Images/boton-aaludica.png",
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