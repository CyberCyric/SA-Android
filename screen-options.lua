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

local globalEventListener
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function readOptionsFile()
  -- Path for the file to read
  local path = system.pathForFile( "options.dat", system.DocumentsDirectory )
  -- Open the file handle
  local file, errorString = io.open( path, "r" )
 
  if not file then
      -- Error occurred; output the cause
      print( "File error: " .. errorString )
  else
      -- Output lines
      for line in file:lines() do
          k, v = string.match(line, "(.*):(.*)")
          if (v == "TRUE") then 
            composer.setVariable(k,true) 
            --print(k.." es TRUE")
          else 
            composer.setVariable(k,false) 
            --print(k.." es FALSE")
          end
      end
      -- Close the file handle
      io.close( file )
  end   
  file = nil
end

local function saveOptionsFile()
    local path = system.pathForFile( "options.dat", system.DocumentsDirectory )
     
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
     
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Write data to file
        if (composer.getVariable( "enableSound")) then file:write("enableSound:TRUE", "\n") else file:write("enableSound:FALSE", "\n") end
        if (composer.getVariable( "confirmPlacement")) then file:write("confirmPlacement:TRUE", "\n") else file:write("confirmPlacement:FALSE", "\n") end
        if (composer.getVariable( "includeVolumen1")) then file:write("includeVolumen1:TRUE", "\n") else file:write("includeVolumen1:FALSE", "\n") end
        if (composer.getVariable( "includeVolumen2")) then file:write("includeVolumen2:TRUE", "\n") else file:write("includeVolumen2:FALSE", "\n") end
        if (composer.getVariable( "includeVolumen3")) then file:write("includeVolumen3:TRUE", "\n") else file:write("includeVolumen3:FALSE", "\n") end
        if (composer.getVariable( "includeVolumen4")) then file:write("includeVolumen4:TRUE", "\n") else file:write("includeVolumen4:FALSE", "\n") end
        if (composer.getVariable( "includeVolumen5")) then file:write("includeVolumen5:TRUE", "\n") else file:write("includeVolumen5:FALSE", "\n") end

        -- print "EN SAVE OPTIONS FILE GUARDE COMO "
        if (composer.getVariable( "confirmPlacement")) then print "TRUE" else print "FALSE" end
        -- Close the file handle
        io.close( file )
    end
     
    file = nil
end
-- Handle press events for the checkbox
local function onSwitchPress( event )    
    local switch = event.target

end

function gotoMenu()
  Runtime:removeEventListener( "key", globalEventListener )
   composer.setVariable( "enableSound", chkSonido.isOn)
   composer.setVariable( "confirmPlacement",  chkConfirmPlacement.isOn)
   --if chkConfirmPlacement.isOn then print "FALSE" else print "TRUE" end
   if chkVol1.isOn then composer.setVariable( "includeVolumen1", true) else composer.setVariable( "includeVolumen1", false) end
   if chkVol2.isOn then composer.setVariable( "includeVolumen2", true) else composer.setVariable( "includeVolumen2", false) end
   if chkVol3.isOn then composer.setVariable( "includeVolumen3", true) else composer.setVariable( "includeVolumen3", false) end
   if chkVol4.isOn then composer.setVariable( "includeVolumen4", true) else composer.setVariable( "includeVolumen4", false) end
   if chkVol5.isOn then composer.setVariable( "includeVolumen5", true) else composer.setVariable( "includeVolumen5", false) end
   if chkVolX.isOn then composer.setVariable( "includeVolumenX", true) else composer.setVariable( "includeVolumenX", false) end

   saveOptionsFile()
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
 
-- create()
function scene:create( event )
 
local sceneGroup = self.view
    readOptionsFile()
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

    lbOpciones = display.newImageRect(sceneGroup, "Images/lbOpciones.png", 150,  23 )
    lbOpciones.anchorX = 0.5
    lbOpciones.anchorY = 0
    lbOpciones.x = leftSide + 160
    lbOpciones.y = topSide + 20 
    
    texto1 = display.newText(sceneGroup, "Elegí con qué volúmenes querés jugar:", 0,0, totalWidth  - 80, 100, "fonts\\georgia.ttf", 20 )
    texto1:setFillColor( 1, 1, 1 )
    texto1.anchorX = 0
    texto1.x = leftSide + 50
    texto1.y = topSide + 130    

    -- Image sheet options and declaration
    local options = {
        width = 50,
        height = 50,
        numFrames = 2,
        sheetContentWidth = 100,
        sheetContentHeight = 50
    }
  local checkboxSheet = graphics.newImageSheet( "Images/checkboxSheet.png", options )
  local checkboxHiddenSheet = graphics.newImageSheet( "Images/checkboxHiddenSheet.png", options )
  local soundSheet = graphics.newImageSheet( "Images/soundSheet.png", options )

  -- Mute option
  chkSonido = widget.newSwitch({ left = leftSide + 30, top = 200, style="checkbox", id = "Checkbox", initialSwitchState =composer.getVariable("enableSound"), onPress = onSwitchPress, sheet = soundSheet, frameOff = 2, frameOn = 1 })
  sceneGroup:insert( chkSonido )
  local txtSonido = display.newText(sceneGroup, "Con sonido" , leftSide + 65 ,255, 150, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtSonido.anchorX = 0
  txtSonido.anchorY = 0
  txtSonido.x = leftSide + 70
  txtSonido.y = 205
  chkSonido.isVisible = false
  txtSonido.isVisible = false

  -- Confirm Placement option
  chkConfirmPlacement = widget.newSwitch({ left = leftSide + 30, top = 250, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("confirmPlacement"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkConfirmPlacement )
  local txtConfirmPlacement = display.newText(sceneGroup, "Colocar con dos toques" , leftSide + 65 ,255, 150, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtConfirmPlacement.anchorX = 0
  txtConfirmPlacement.anchorY = 0
  txtConfirmPlacement.x = leftSide + 70
  txtConfirmPlacement.y = 255
  chkConfirmPlacement.isVisible = false
  txtConfirmPlacement.isVisible = false

  chkVol1 =  widget.newSwitch({ left = leftSide + 70, top = 130, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumen1"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVol1 )
  local imgVol1 = display.newImage(sceneGroup, "Images/sa_vol1.jpg" )
  imgVol1.anchorX = 0
  imgVol1.anchorY  = 0
  imgVol1.x = leftSide + 120
  imgVol1.y = 125
  imgVol1.width = 30
  imgVol1.height = 42
  local txtVol1 = display.newText(sceneGroup, "Volúmen 1:\nGobiernos y Conflictos" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVol1.anchorX = 0
  txtVol1.anchorY = 0
  txtVol1.x = leftSide + 160
  txtVol1.y = 125

  chkVol2 =  widget.newSwitch({ left = leftSide + 340, top = 130, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumen2"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVol2 )
  local imgVol2 = display.newImage(sceneGroup, "Images/sa_vol2.jpg" )
  imgVol2.anchorX = 0
  imgVol2.anchorY  = 0
  imgVol2.x = leftSide + 390
  imgVol2.y = 125
  imgVol2.width = 30
  imgVol2.height =  42 
  local txtVol2 = display.newText(sceneGroup, "Volúmen 2:\nEconomía y Sociedad" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVol2.anchorX = 0
  txtVol2.anchorY = 0
  txtVol2.x = leftSide + 430
  txtVol2.y = 125

  chkVol3 =  widget.newSwitch({ left = leftSide + 70, top = 180, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumen3"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVol3 )
  local imgVol3 = display.newImage(sceneGroup, "Images/sa_vol3.jpg" )
  imgVol3.anchorX = 0
  imgVol3.anchorY  = 0
  imgVol3.x = leftSide + 120
  imgVol3.y = 175
  imgVol3.width = 30
  imgVol3.height = 42  
  local txtVol3 = display.newText(sceneGroup, "Volúmen 3:\nCiencia y Cultura" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVol3.anchorX = 0
  txtVol3.anchorY = 0
  txtVol3.x = leftSide + 160
  txtVol3.y = 175

  chkVol4 =  widget.newSwitch({ left = leftSide + 340, top = 180, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumen4"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVol4 )
  local imgVol4 = display.newImage(sceneGroup, "Images/sa_vol4.jpg" )
  imgVol4.anchorX = 0
  imgVol4.anchorY  = 0
  imgVol4.x = leftSide + 390
  imgVol4.y = 175
  imgVol4.width = 30
  imgVol4.height = 42  
  local txtVol4 = display.newText(sceneGroup, "Volúmen 4:\nCambalache" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVol4.anchorX = 0
  txtVol4.anchorY = 0
  txtVol4.x = leftSide + 430
  txtVol4.y = 175

  chkVol5 =  widget.newSwitch({ left = leftSide + 70, top = 220, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumen5"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVol5 )
  local txtVol5 = display.newText(sceneGroup, "Volúmen 5:\nDeportes (próximamente)" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVol5:setFillColor( 0.8, 0.8, 0.8 )
  txtVol5.anchorX = 0
  txtVol5.anchorY = 0
  txtVol5.x = leftSide + 160
  txtVol5.y = 215
  chkVol5.isVisible = false
  txtVol5.isVisible = false

  chkVolX =  widget.newSwitch({ left = leftSide + 340, top = 220, style="checkbox", id = "Checkbox", initialSwitchState=composer.getVariable("includeVolumenX"), onPress = onSwitchPress, sheet = checkboxSheet, frameOff = 1, frameOn = 2 })
  sceneGroup:insert( chkVolX )
  local txtVolX = display.newText(sceneGroup, "Cartas Inéditas" , leftSide + 165 ,255, 250, 170,"fonts\\FjallaOne-Regular.ttf", 16, center )
  txtVolX.anchorX = 0
  txtVolX.anchorY = 0
  txtVolX.x = leftSide + 390
  txtVolX.y = 230

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