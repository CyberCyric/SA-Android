local composer = require( "composer" )
local widget = require( "widget" )
local utils = require( "utils" )
local scene = composer.newScene()
local globalData = require( "globalData" )
local json = require( "json" )

local leftSide = display.screenOriginX;
local rightSide = display.contentWidth-display.screenOriginX;
local topSide = display.screenOriginY;
local bottomSide = display.contentHeight-display.screenOriginY;
local totalWidth = display.contentWidth-(display.screenOriginX*2);
local totalHeight = display.contentHeight-(display.screenOriginY*2);
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;

local butDailyRanking
local butMonthlyRanking
local butAllTimeRanking

local leaderboardTable

local globalEventListener
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
  
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- ELIMINAR!!
local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- Alias to print results from dump
-- [To-Do] Move to "utils" file?
local function pd(o)
  print(dump(o))
end 

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function gotoMenu()
  Runtime:removeEventListener( "key", globalEventListener )
  composer.gotoScene('screen-menu')
end

-- Google Play Games Services initialization/login listener

local function leaderboardListener( event )

    leaderboardTable:deleteAllRows()

    -- Insert Header Row:
    leaderboardTable:insertRow(
    {
        isCategory = true,
        rowHeight = 28,
        rowColor = { default={0.87, 0.75, 0.59} },
        lineColor = { 0.5, 0.5, 0.5 },
        params = {
          rank = "#",
          score = "CARTAS",
          name = "JUGADOR",
          image = ""
        }
    })

    -- ORDENAR LEADERBOARD por RANK
    function spairs(t, order)
        -- collect the keys
        local keys = {}
        for k in pairs(t) do keys[#keys+1] = k end

        -- if order function given, sort by it by passing the table and keys a, b,
        -- otherwise just sort the keys 
        if order then
            table.sort(keys, function(a,b) return order(t, a, b) end)
        else
            table.sort(keys)
        end

        -- return the iterator function
        local i = 0
        return function()
            i = i + 1
            if keys[i] then
                return keys[i], t[keys[i]]
            end
        end
    end
    
    for k,v in spairs(event.scores, function(t,a,b) return t[b].rank > t[a].rank end) do
      print("---> AGREGRO A LA TABLA el row "..k.." con valores:"..v.rank..":"..v.score)
      leaderboardTable:insertRow{
        rowHeight = 28,
        isCategory = false,
        rowColor = { 0.5, 1, 1 },
        lineColor = { 0.90, 0.90, 0.90 },
        params = {
          rank = v.rank,
          score = v.score,
          name = v.player.name,
          image = v.player.smallImageUri
        }
      }
      
    end

end


local function displayLeaderboard( timeSpan )
  if ( globalData.gpgs.isConnected() ) then   
    -- globalData.gpgs.leaderboards.show( "CgkIl_HAoI0OEAIQAQ" )
    print("Llamando al leaderboard con TS:"..timeSpan)
    globalData.gpgs.leaderboards.loadScores( {
        leaderboardId = "CgkIl_HAoI0OEAIQAQ",
        listener = leaderboardListener,
        timeSpan = timeSpan,
        friendsOnly = false,
        limit = 20,
        reload = true
    })
  else
    leaderboardTable:deleteAllRows()
    leaderboardTable:insertRow(
    {
        isCategory = true,
        rowHeight = 28,
        rowColor = { default={1, 1, 1} },
        lineColor = { 0.5, 0.5, 0.5 },
        params = {
          rank = "",
          score = "No se pudo conectar a Internet.",
          name = "",
          image = ""
        }
    })
  end
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

local function handleButtonEvent( event )
    if (event.target.id == 'back') then
        gotoMenu()
    end
    
    if (event.target.id == 'dailyRanking') then
        butDailyRanking:setFillColor( 0.43, 0.37, 0.28 )
        butMonthlyRanking:setFillColor(1 , 1 , 1)
        butAllTimeRanking:setFillColor(1 , 1 , 1)
        if (globalData.gpgs) then displayLeaderboard( "daily" ) end
    end
    if (event.target.id == 'monthlyRanking') then
        butDailyRanking:setFillColor(1 , 1 , 1)
        butMonthlyRanking:setFillColor( 0.43, 0.37, 0.28 )
        butAllTimeRanking:setFillColor(1 , 1 , 1)
        if (globalData.gpgs) then displayLeaderboard( "weekly" ) end
    end
    if (event.target.id == 'allTimeRanking') then
        butDailyRanking:setFillColor(1 , 1 , 1)
        butMonthlyRanking:setFillColor(1 , 1 , 1)
        butAllTimeRanking:setFillColor( 0.43, 0.37, 0.28 )
        if (globalData.gpgs) then displayLeaderboard( "all time" ) end
    end    
end

local function onRowRender( event )
 
   --Set up the localized variables to be passed via the event table
 
   local row = event.row
   local id = row.index
   local params = event.row.params
   local rowHeight = row.contentHeight
   local rowWidth = row.contentWidth
  
       if ( event.row.params ) then   

          row.rankText = display.newText( params.rank, 12, 0, native.systemFontBold, 18 )
          row.rankText.anchorX = 0
          row.rankText.anchorY = 0.5
          if (id ==1) then row.rankText:setFillColor( 0 ) else row.rankText:setFillColor( 0.5 ) end
          row.rankText.x = 20
          row.rankText.y = 20               
     
          row.scoreText = display.newText( params.score, 12, 0, native.systemFont, 18 )
          row.scoreText.anchorX = 0
          row.scoreText.anchorY = 0.5
          if (id ==1) then row.scoreText:setFillColor( 0 ) else row.scoreText:setFillColor( 0.5 ) end
          if (id ==1) then row.scoreText.x = 65 else  row.scoreText.x = 90 end
          row.scoreText.y = 20
     
          row.nameText = display.newText( params.name, 12, 0, native.systemFont, 18 )
          row.nameText.anchorX = 0
          row.nameText.anchorY = 0.5
          if (id ==1) then row.nameText:setFillColor( 0 ) else row.nameText:setFillColor( 0.5 ) end
          row.nameText.x = 250
          row.nameText.y = 20     

          row:insert( row.rankText )
          row:insert( row.scoreText )
          row:insert( row.nameText )

          --[[
          if ( id > 1 and params.image ~= nil ) then
            row.playerImage = globalData.gpgs.loadImage( {uri=params.image, filename='img'..params.name } )
            row.nameText.x = 200
            row.nameText.y = 20             
            row:insert( row.playerImage )
          end 
          ]]--         

       end
   
   return true
end


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    composer.removeScene( "screen-game" )
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
    logoImage:addEventListener("tap", gotoMenu)

     lbOpciones = display.newImageRect(sceneGroup, "Images/lbRanking.png", 380,  50 )
     utils.fitImage(lbOpciones, 200, 90, false)
     lbOpciones.anchorX = 1
     lbOpciones.anchorY = 0
     lbOpciones.x = rightSide - 20
     lbOpciones.y = topSide + 20   

    local navBarHeight = 110
    local tabBarHeight = 50

   leaderboardTable = widget.newTableView {
      top = topSide +60, 
      width = totalWidth - 60, 
      height = display.contentHeight - navBarHeight - tabBarHeight,
      onRowRender = onRowRender,
      listener = scrollListener
    }
    leaderboardTable.x = leftSide + 30
    leaderboardTable.anchorX = 0
    leaderboardTable.anchorY = 0
    sceneGroup:insert( leaderboardTable ) 

 -- Insert "Loading..." Row:
 if ( globalData.gpgs ) then
    leaderboardTable:insertRow({
        isCategory = true,
        rowHeight = 28,
        rowColor = { default={1, 1, 1} },
        lineColor = { 0.5, 0.5, 0.5 },
        params = {
          rank = "",
          score = "Cargando...",
          name = "",
          image = ""
        }
    })
  else
    leaderboardTable:insertRow(
    {
        isCategory = true,
        rowHeight = 28,
        rowColor = { default={1, 1, 1} },
        lineColor = { 0.5, 0.5, 0.5 },
        params = {
          rank = "",
          score = "No se pudo conectar a Internet.",
          name = "",
          image = ""
        }
    })
  end

    butDailyRanking = widget.newButton({ 
        id = "dailyRanking",
        width = (totalWidth - 60) / 3,
        height = 40,
        defaultFile = "Images/box.png",
        label = "Diario",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butDailyRanking.x = leftSide + 30
    butDailyRanking.y = topSide + 100
    butDailyRanking.anchorX = 0
    butDailyRanking.anchorY = 0
    sceneGroup:insert( butDailyRanking )

    butMonthlyRanking = widget.newButton({ 
        id = "monthlyRanking",
        width = (totalWidth - 60) / 3,
        height = 40,
        defaultFile = "Images/box.png",
        label = "Semanal",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butMonthlyRanking.x = centerX 
    butMonthlyRanking.y = topSide + 100
    butMonthlyRanking.anchorX = 0.5
    butMonthlyRanking.anchorY = 0
    sceneGroup:insert( butMonthlyRanking )

    butAllTimeRanking = widget.newButton({ 
        id = "allTimeRanking",
        width = (totalWidth - 60) / 3,
        height = 40,
        defaultFile = "Images/box.png",
        label = "Global",
        onRelease = handleButtonEvent
    })
    -- Center the button
    butAllTimeRanking.x = rightSide -30
    butAllTimeRanking.y = topSide + 100
    butAllTimeRanking.anchorX = 1
    butAllTimeRanking.anchorY = 0
    butAllTimeRanking:setFillColor( 0.43, 0.37, 0.28 )
    sceneGroup:insert( butAllTimeRanking )        
end

local function loginHandler( event )
    if not event.isError then
        if ( event.name == "login" ) then
            displayLeaderboard( "all time" )
        end
    else
        print("ERROR EN EL LOGIN DE SCREEN-LEADERBOARDS")
    end    
end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        if ( globalData.gpgs ) then
            if (globalData.gpgs.isConnected()) then
                displayLeaderboard( "all time" )
            else
                globalData.gpgs.login( { userInitiated=true, listener=loginHandler } )
            end
        end        
 
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