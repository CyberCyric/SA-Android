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

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
local function handleButtonEvent( event )
    if (event.target.id == 'back') then
        composer.gotoScene('screen-menu')
    end
end


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

--[[
    local butAAludica = widget.newButton({  
        id = 'back',
        defaultFile = "Images/boton-aaludica.png",
        -- overFile = "buttonOver.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butAAludica.x = display.contentWidth /2 + 100
    butAAludica.y = display.contentHeight - 50
    butAAludica.anchorX = 0
    butAAludica.anchorY = 0
    utils.fitImage(butAAludica, 180, 39, false)
    sceneGroup:insert( butAAludica )
]]--
    local butCerrar = widget.newButton({  
        id = 'back',
        defaultFile = "Images/boton-cerrar.png",
        -- overFile = "buttonOver.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butCerrar.x = display.contentWidth - 50
    butCerrar.y = 15
    butCerrar.anchorX = 0
    butCerrar.anchorY = 0
    utils.fitImage(butCerrar, 25, 25, false)
    sceneGroup:insert( butCerrar )  

    local function openAASite( event )  
        system.openURL( "http://www.aaludica.com.ar" ) 
    end

    local foregroundImage = display.newImage(sceneGroup, "Images/screen-comprar.png" )
    foregroundImage.anchorX = 0
    foregroundImage.anchorY = 0
    utils.fitImage(foregroundImage, display.contentWidth, display.contentHeight, false)
    foregroundImage:addEventListener('tap', openAASite)
    sceneGroup:insert( foregroundImage )   
 
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