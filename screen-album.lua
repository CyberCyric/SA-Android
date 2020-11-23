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
local sceneGroup = composer.newScene()
local scCards
local globalEventListener

local butVolX
local butVol1
local butVol2
local butVol3
local butVol4
local butVol5

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
function drawCards(volume)

    if (scCards == nil) then
    else
        scCards:removeSelf()
    end
    
    local options = {
        verticalScrollDisabled  = true,
        hideBackground = true,
        height = 170
    }
    scCards = widget.newScrollView( options )
    scCards.anchorY = 0
    scCards.y = topSide + 140
    sceneGroup:insert(scCards)

    path = system.pathForFile( "data.db", system.DocumentsDirectory )
    local db = sqlite3.open( path )
    local SQL = "SELECT * FROM cartas WHERE vol='"..volume.."'"
    print(SQL)
    i = 0
    for row in db:nrows(SQL) do
        i = i +1
        --[[
        local options1 =  {
            text = "["..i.."]",
            x = totalWidth * (i) / 5 + 30,
            y = topSide + 360, 
            width = 80,
            height = 100,
            font = native.systemFont,   
            fontSize = 8,
            align = "center"  -- Alignment parameter
        }

        local numero = display.newText( options1 )
        numero:setFillColor( 1, 1, 1 )
        ]]--

        local cardImage = display.newImage( "Images/Cartas/locked.jpg" )
        cardImage.x = (totalWidth * (i) / 5) - 50
        cardImage.y = topSide + 70
        cardImage.width = 90
        cardImage.height = 125
        
        local options2 =  {
            text = '',
            x = (totalWidth * (i) / 5) - 50,
            y = topSide + 185,
            width = 80,
            height = 100,
            font = native.systemFont,   
            fontSize = 8,
            align = "center"  -- Alignment parameter
        }

        local titulo = display.newText( options2 )
        titulo:setFillColor( 1, 1, 1 )

        if (row.unlocked == 'Y') then
            if (utils.file_exists("Images/Cartas/"..row.image) == true) then
                cardImage = utils.swapImage(cardImage, "Images/Cartas/"..row.image, 92, 127, scCards, 0 )
            else
                cardImage = utils.swapImage(cardImage, "Images/Cartas/0.jpg", 92, 127, scCards, 0 )
            end
            cardImage:setStrokeColor( 0.43, 0.37, 0.28 )
            cardImage.strokeWidth = 2
            titulo.text = row.title
        else
            titulo.text = '?'
        end       

        -- scCards:insert( numero ) 
        scCards:insert( cardImage ) 
        scCards:insert( titulo )  

    end
    db:close()

end

function gotoMenu()
  Runtime:removeEventListener( "key", globalEventListener)
  composer.gotoScene('screen-menu')
end

globalEventListener = function( event )
    if ( event.keyName == "back" ) then       
        if (event.phase == "up") then
            gotoMenu()
          return true
        end
    end        
end
Runtime:addEventListener( "key", globalEventListener )

local function handleButtonEvent(event)

    if (event.target.id == 'butVolX') then
        drawCards('X')
        butVolX:setFillColor( 0.43, 0.37, 0.28 )
        butVol1:setFillColor(1 , 1 , 1)
        butVol2:setFillColor(1 , 1 , 1)
        butVol3:setFillColor(1 , 1 , 1)
        butVol4:setFillColor(1 , 1 , 1)
        butVol5:setFillColor(1 , 1 , 1)
    end
    if (event.target.id == 'butVol1') then
        drawCards('1')
        butVol1:setFillColor( 0.43, 0.37, 0.28 )
        butVolX:setFillColor(1 , 1 , 1)
        butVol2:setFillColor(1 , 1 , 1)
        butVol3:setFillColor(1 , 1 , 1)
        butVol4:setFillColor(1 , 1 , 1)
        butVol5:setFillColor(1 , 1 , 1)
    end
    if (event.target.id == 'butVol2') then
        drawCards('2')
        butVol2:setFillColor( 0.43, 0.37, 0.28 )
        butVol1:setFillColor(1 , 1 , 1)
        butVolX:setFillColor(1 , 1 , 1)
        butVol3:setFillColor(1 , 1 , 1)
        butVol4:setFillColor(1 , 1 , 1)
        butVol5:setFillColor(1 , 1 , 1)
    end
    if (event.target.id == 'butVol3') then
        drawCards('3')
        butVol3:setFillColor( 0.43, 0.37, 0.28 )
        butVol1:setFillColor(1 , 1 , 1)
        butVol2:setFillColor(1 , 1 , 1)
        butVolX:setFillColor(1 , 1 , 1)
        butVol4:setFillColor(1 , 1 , 1)
        butVol5:setFillColor(1 , 1 , 1)
    end
    if (event.target.id == 'butVol4') then
        drawCards('4')
        butVol4:setFillColor( 0.43, 0.37, 0.28 )
        butVol1:setFillColor(1 , 1 , 1)
        butVol2:setFillColor(1 , 1 , 1)
        butVol3:setFillColor(1 , 1 , 1)
        butVolX:setFillColor(1 , 1 , 1)
        butVol5:setFillColor(1 , 1 , 1)
    end
    if (event.target.id == 'butVol5') then
        drawCards('5')
        butVol1:setFillColor(1 , 1 , 1)
        butVol2:setFillColor(1 , 1 , 1)
        butVol3:setFillColor(1 , 1 , 1)
        butVol4:setFillColor(1 , 1 , 1)
        butVol5:setFillColor( 0.43, 0.37, 0.28 )
        butVolX:setFillColor(1 , 1 , 1)
    end
end

-- create()
function scene:create( event )
 
    sceneGroup = self.view
    composer.removeScene( "screen-game" )

    -- Code here runs when the scene is first created but has not yet appeared on screen
    local backgroundImage = display.newImage(sceneGroup, "Images/background.jpg" )
    backgroundImage.anchorX = 0
    backgroundImage.anchorY = 0
    backgroundImage.x = leftSide
    backgroundImage.y = topSide

     lbOpciones = display.newImageRect(sceneGroup, "Images/lbCartas.png", 380,  50 )
     utils.fitImage(lbOpciones, 200, 90, false)
     lbOpciones.anchorX = 1
     lbOpciones.anchorY = 0
     lbOpciones.x = rightSide - 20
     lbOpciones.y = topSide + 20    

    local logoImage = display.newImage(sceneGroup, "Images/logoSA-lg.png" )
    logoImage.anchorX = 0
    logoImage.anchorY  = 0
    logoImage.x = leftSide+10
    logoImage.y = topSide+10
    utils.fitImage(logoImage, 200 , 133 , false)
    logoImage:addEventListener("tap", gotoMenu) 

    butVolX = widget.newButton({ 
        id = "butVolX",
        width = 70,
        height = 30,
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-volX-on.png",
        labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
        onRelease = handleButtonEvent
    })
    butVolX.x = rightSide - 60
    butVolX.y = topSide + 100
    butVolX.anchorX = 0.5
    butVolX.anchorY = 0
    sceneGroup:insert( butVolX )
    local txtVolX = display.newText(sceneGroup, "Vol X" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVolX.anchorX = 0
    txtVolX.anchorY = 0
    txtVolX.x = rightSide - 74
    txtVolX.y = topSide + 105

    butVol1 = widget.newButton({ 
        id = "butVol1",
        width = 70,
        height = 30,
        defaultFile = "Images/box.png",
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-vol1-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butVol1.x = rightSide - 385
    butVol1.y = topSide + 100
    butVol1.anchorX = 0.5
    butVol1.anchorY = 0
    sceneGroup:insert( butVol1 )
    local txtVol1 = display.newText(sceneGroup, "Vol 1" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVol1.anchorX = 0
    txtVol1.anchorY = 0
    txtVol1.x = rightSide - 399
    txtVol1.y = topSide + 105

    butVol2 = widget.newButton({ 
        id = "butVol2",
        width = 70,
        height = 30,
        defaultFile = "Images/box.png",
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-vol2-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butVol2.x = rightSide - 320
    butVol2.y = topSide + 100
    butVol2.anchorX = 0.5
    butVol2.anchorY = 0
    sceneGroup:insert( butVol2 )
    local txtVol2 = display.newText(sceneGroup, "Vol 2" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVol2.anchorX = 0
    txtVol2.anchorY = 0
    txtVol2.x = rightSide - 334
    txtVol2.y = topSide + 105

    butVol3 = widget.newButton({ 
        id = "butVol3",
        width = 70,
        height = 30,
        defaultFile = "Images/box.png",
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-vol3-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butVol3.x = rightSide - 255
    butVol3.y = topSide + 100
    butVol3.anchorX = 0.5
    butVol3.anchorY = 0
    sceneGroup:insert( butVol3 )
    local txtVol3 = display.newText(sceneGroup, "Vol 3" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVol3.anchorX = 0
    txtVol3.anchorY = 0
    txtVol3.x = rightSide - 269
    txtVol3.y = topSide + 105

    butVol4 = widget.newButton({ 
        id = "butVol4",
        width = 70,
        height = 30,
        defaultFile = "Images/box.png",
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-vol3-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butVol4.x = rightSide - 190
    butVol4.y = topSide + 100
    butVol4.anchorX = 0.5
    butVol4.anchorY = 0
    sceneGroup:insert( butVol4 )
    local txtVol4 = display.newText(sceneGroup, "Vol 4" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVol4.anchorX = 0
    txtVol4.anchorY = 0
    txtVol4.x = rightSide - 204
    txtVol4.y = topSide + 105

     butVol5 = widget.newButton({ 
        id = "butVol5",
        width = 70,
        height = 30,
        defaultFile = "Images/box.png",
        defaultFile = "Images/boton-vol-off.png",
        --overFile = "Images/boton-vol3-on.png",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butVol5.x = rightSide - 125
    butVol5.y = topSide + 100
    butVol5.anchorX = 0.5
    butVol5.anchorY = 0
    sceneGroup:insert( butVol5 )
    local txtVol5 = display.newText(sceneGroup, "Vol 5" , leftSide + 165 ,255, 250, 170,"fonts\FjallaOne-Regular.ttf", 16, center )
    txtVol5.anchorX = 0
    txtVol5.anchorY = 0
    txtVol5.x = rightSide - 139
    txtVol5.y = topSide + 105
    
      
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