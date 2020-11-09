local composer = require( "composer" )
local utils = require( "utils" )
local globalData = require( "globalData" )
local platform = system.getInfo( "platform" )
local env = system.getInfo( "environment" )

local leftSide = display.screenOriginX;
local rightSide = display.contentWidth-display.screenOriginX;
local topSide = display.screenOriginY;
local bottomSide = display.contentHeight-display.screenOriginY;
local totalWidth = display.contentWidth-(display.screenOriginX*2);
local totalHeight = display.contentHeight-(display.screenOriginY*2);
local centerX = display.contentCenterX;
local centerY = display.contentCenterY;
local isMoving = false

local tableauTooltip0 = nil

local scene = composer.newScene()
local timeline = {}
local deck = {}
local activeCard = nil
local highScore = 0

local MAX_SECONDS_TIMER = 15
local secondsLeft = MAX_SECONDS_TIMER  
local clockText = nil
local countDownTimer

local activeCardGroup = display.newGroup()
local timelineGroup = display.newGroup()
local gameoverGroup = display.newGroup()

if ( platform == "android" and env ~= "simulator" ) then
    globalData.gpgs = require( "plugin.gpgs.v2" )
    print("gpgs plugin started")
end

local soundTable = {
    startSound = audio.loadSound( "Audio/start.mp3" ),
    okSound = audio.loadSound( "Audio/ok.wav" ),
    failSound = audio.loadSound( "Audio/fail.mp3" )
}

local loadDeck
local swipeHandler
local drawTableau
local globalEventListener

-- Google Play License
if ( platform == "android" and env ~= "simulator" ) then
    local licensing = require( "licensing" )
     
    local function licensingListener( event )
     
        if not ( event.isVerified ) then
            -- Failed to verify app from the Google Play store; print a message
            print( "Pirates!!!" )
        else
            print( "License OK")
        end
    end
 
    local licensingInit = licensing.init( "google" )
 
if ( licensingInit == true ) then
    licensing.verify( licensingListener )
end

end 

-- Google Play Games Services initialization/login listener
local function gpgsInitListener( event )

    if not event.isError then
        if ( event.name == "init" ) then  -- Initialization event
            -- print("INIT")
            -- Attempt to log in the user
            globalData.gpgs.login( { userInitiated=true, listener=gpgsInitListener } )
        elseif ( event.name == "login" ) then  -- Successful login event            
            -- print("LOGIN")
        end
    else
        print("ERROR "..event.errorCode..": "..event.errorMessage)
    end    
end
 
-- ------------------------------------------------------------------------------------
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
-- ------------------------------------------------------------------------------------

local function saveHighScore(newScore)
    -- Path for the file to write
    print("Estoy por guardar nuevo HS: "..newScore)
    local path = system.pathForFile( "score.dat", system.DocumentsDirectory )
     
    -- Open the file handle
    local file, errorString = io.open( path, "w" )
     
    if not file then
        -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Write data to file
        file:write( newScore )
        -- Close the file handle
        io.close( file )
    end
     
    file = nil
end

local function showGameOverScreen(isDeckEmpty, isTimerEmpty)
    totalCartas = composer.getVariable("timelineSize") - 1
    hs = composer.getVariable("highscore")

    if (isDeckEmpty) then 
        boxGameOverText.text = "¡ Juego terminado !"
        boxGameOverSubtext.text =  "Colocaste correctamente "..totalCartas.." cartas. " 
        if (totalCartas > tonumber(hs) ) then
            boxGameOverSubtext2.text = "( ¡Es tu nuevo récord! )"
        else
            boxGameOverSubtext2.text = "( Tu récord es de "..composer.getVariable("highscore")..")."
        end
    elseif (isTimerEmpty) then
       boxGameOverText.text = "¡Se terminó el tiempo!"
       boxGameOverSubtext.text =  "Colocaste "..totalCartas.." cartas. " 
        if (totalCartas > tonumber(hs) ) then
            boxGameOverSubtext.text = boxGameOverSubtext.text.."¡Es tu nuevo récord personal!"
        else
            boxGameOverSubtext.text = boxGameOverSubtext.text.."( Tu récord personal es de "..composer.getVariable("highscore").." )."
        end
    else
         boxGameOverText.text = "¡Acertaste todas las cartas!"
         boxGameOverSubtext.text =  "Colocaste "..totalCartas.." cartas. ( Tu récord personal es de "..composer.getVariable("highscore").." )."
    end    

    -- Compruebo si unlockea alguna carta
    math.randomseed(os.time())
    local rnd = math.random(1,100)

    if (rnd <= #timeline * 3) then
        boxGameOverText.y = 50
        boxGameOverSubtext.y = 80 
        -- Obtengo una carta Locked al azar y la Unlockeo
        path = system.pathForFile( "data.db", system.DocumentsDirectory )
        db = sqlite3.open( path )
        SQL = "SELECT * FROM cartas WHERE unlocked='N' ORDER BY RANDOM() LIMIT 1"
        i = 0
        local carta = nil
        for row in db:nrows(SQL) do
            i = i + 1
            carta = row
        end
        
        if (i > 0) then
            unlockedCardBox.isVisible = true
            boxGameOverUnlockedSubtext.text = "'"..carta.title.."' fue agregada a tu colección."
            unlockedCard = utils.swapImage(unlockedCard, "Images/Cartas/"..carta.image,90, 125, gameoverGroup, 0 )
            unlockedCard:setStrokeColor( 0.58, 0.53, 0.4)
            unlockedCard.strokeWidth = 5
            boxGameOverUnlockedText.isVisible = true
            boxGameOverUnlockedSubtext.isVisible = true
            unlockedCard.isVisible = true

            path = system.pathForFile( "data.db", system.DocumentsDirectory )
            db = sqlite3.open( path )
            SQL = "UPDATE cartas SET unlocked='Y' WHERE carta_id="..carta.carta_id
            db:exec( SQL )
            if db:errcode() then
                print(db:errcode(), db:errmsg())
            end
        else
            boxGameOverUnlockedText.isVisible = false
            boxGameOverUnlockedSubtext.isVisible = false
            unlockedCard.isVisible = false
        end
        db:close()
    else  
        -- Unlockeo cartas
        unlockedCardBox.isVisible = false
        boxGameOverText.y = 80
        boxGameOverSubtext.y = 120 
        boxGameOverUnlockedText.isVisible = false
        boxGameOverUnlockedSubtext.isVisible = false
        unlockedCard.isVisible = false
    end
    gameoverGroup.isVisible = true
end

local function pageRight( positions )
    isMoving = true
    if (#timeline > 2 and timelineIndex < #timeline -1) then
        tableauArrow1.isSecondTap = false
        tableauArrow2.isSecondTap = false
        tableauArrow3.isSecondTap = false
        tableauArrow4.isSecondTap = false
        tableauArrow1:setFillColor(1 , 1 , 1)
        tableauArrow2:setFillColor(1 , 1 , 1)
        tableauArrow3:setFillColor(1 , 1 , 1)
        tableauArrow4:setFillColor(1 , 1 , 1)
        timelineIndex =  timelineIndex + positions
    end
    drawTableau()
end

local function pageLeft( positions )
    isMoving = true
    if (#timeline > 2 and timelineIndex > 2) then
        tableauArrow1.isSecondTap = false
        tableauArrow2.isSecondTap = false
        tableauArrow3.isSecondTap = false
        tableauArrow4.isSecondTap = false
        tableauArrow1:setFillColor(1 , 1 , 1)
        tableauArrow2:setFillColor(1 , 1 , 1)
        tableauArrow3:setFillColor(1 , 1 , 1)
        tableauArrow4:setFillColor(1 , 1 , 1)
        timelineIndex =  timelineIndex - positions
    end
    drawTableau()
end

local function timelineCardHandle( event )
    local order = event.target.order

    if event.phase == "began" then
        if(order == 1) then 
            tableauCardTitle1.isVisible = true  
            tableauCardTitle1.parent:insert( tableauCardTitle1 )
        end
        if(order == 2) then 
            tableauCardTitle2.isVisible = true  
            tableauCardTitle2.parent:insert( tableauCardTitle2 )
        end
        if(order == 3) then 
            tableauCardTitle3.isVisible = true  
            tableauCardTitle3.parent:insert( tableauCardTitle3 )
        end
        if(order == 4) then 
            tableauCardTitle4.isVisible = true  
            tableauCardTitle4.parent:insert( tableauCardTitle4 )
        end
        if(order == 5) then 
            tableauCardTitle5.isVisible = true  
            tableauCardTitle5.parent:insert( tableauCardTitle5 )
        end     
    end

    if ( event.phase == "ended" or event.phase == "moved") then
        tableauCardTitle1.isVisible = false
        tableauCardTitle2.isVisible = false
        tableauCardTitle3.isVisible = false
        tableauCardTitle4.isVisible = false
        tableauCardTitle5.isVisible = false
    end

end

local function getCurrentHighScore()
    local path = system.pathForFile( "score.dat", system.DocumentsDirectory )
    local file, errorString = io.open( path, "r" )
    if not file then
        -- Creo el archivo
       file, errorString = io.open( path, "w" ) 
       file:write( "0" )
       highScore = "0"     
    else
        -- Read data from file
        local contents = file:read( "*a" )
        -- Output the file contents
        highScore = contents
    end 
    print("HS:"..highScore)
    composer.setVariable("highscore", highScore)
    io.close( file )
    file = nil  
end

drawTableau =  function()

    local card = nil
    timelineGroup.isVisible = true

    -- Displays the C (center) card
    if (#timeline > 0 and timelineIndex > 0) then
        card = timeline[timelineIndex]
        tableauCardYear3.text = ''
        tableauCardYear3.text = card.year
        tableauCardYear3.isVisible = true
        tableauCardTitle3.text = card.title
        tableauCard3 = utils.swapImage(tableauCard3, "Images/Cartas/"..card.image,50, 70, timelineGroup, 3 )         
        tableauCard3:addEventListener( "touch", timelineCardHandle )
        if (card.isValid == false) then tableauCard3:setFillColor( 1, 0, 0, 0.5 ) else tableauCard3:setFillColor( 1, 1, 1, 1 ) end
    end

    -- Display the B card
    if (#timeline > 1 and timelineIndex >1) then
        card = timeline[timelineIndex-1]
        tableauCardYear2.text = card.year
        tableauCard2.isVisible = true
        tableauCardYear2.isVisible = true
        tableauCardTitle2.text = card.title
        tableauCard2 = utils.swapImage(tableauCard2, "Images/Cartas/"..card.image,50, 70, timelineGroup, 2 )   
        tableauCard2:addEventListener( "touch", timelineCardHandle )
        if (card.isValid == false) then tableauCard2:setFillColor( 1, 0, 0, 0.5 ) else tableauCard2:setFillColor( 1, 1, 1, 1 ) end

    else
        tableauCard2.isVisible = false
        tableauCardYear2.isVisible = false
    end
    -- Display the A card
    if (#timeline > 2 and timelineIndex > 2) then
        card = timeline[timelineIndex-2]
        tableauCardYear1.text = card.year
        tableauCard1.isVisible = true       
        tableauCardYear1.isVisible = true
        tableauCardTitle1.text = card.title
        tableauCard1 = utils.swapImage(tableauCard1, "Images/Cartas/"..card.image,50, 70, timelineGroup, 1 ) 
        tableauCard1:addEventListener( "touch", timelineCardHandle )
        if (card.isValid == false) then tableauCard1:setFillColor( 1, 0, 0, 0.5 ) else tableauCard1:setFillColor( 1, 1, 1, 1 ) end

    else
        tableauCard1.isVisible = false
        tableauCardYear1.isVisible = false

    end 

    -- Display the D card
    if (#timeline > 1 and timelineIndex < #timeline) then
        card = timeline[timelineIndex+1]
        tableauCardYear4.text = card.year
        tableauCard4.isVisible = true
        tableauCardYear4.isVisible = true
        tableauCardTitle4.text = card.title
        tableauCard4 = utils.swapImage(tableauCard4, "Images/Cartas/"..card.image,50, 70, timelineGroup, 4 ) 
        tableauCard4:addEventListener( "touch", timelineCardHandle )
        if (card.isValid == false) then tableauCard4:setFillColor( 1, 0, 0, 0.5 ) else tableauCard4:setFillColor( 1, 1, 1, 1 ) end
    else
        tableauCard4.isVisible = false
        tableauCardYear4.isVisible = false
    end     

    -- Display the E card
    if (#timeline > 2 and timelineIndex < #timeline-1) then
        card = timeline[timelineIndex+2]
        tableauCardYear5.text = card.year
        tableauCard5.isVisible = true
        tableauCardYear5.isVisible = true
        tableauCardTitle5.text = card.title
        tableauCard5 = utils.swapImage(tableauCard5, "Images/Cartas/"..card.image,50, 70, timelineGroup, 5 ) 
        tableauCard5:addEventListener( "touch", timelineCardHandle )
        if (card.isValid == false) then tableauCard5:setFillColor( 1, 0, 0, 0.5 ) else tableauCard5:setFillColor( 1, 1, 1, 1 ) end
    else
        tableauCard5.isVisible = false
        tableauCardYear5.isVisible = false
    end     

    -- Display the first Arrow Down
    if (#timeline > 1 and timelineIndex >1 and gameInProgress == true) then
        tableauArrow1.isVisible = true
    else
        tableauArrow1.isVisible = false
    end
    
    -- Display the last Arrow Down
    if (#timeline > 1 and timelineIndex < #timeline and gameInProgress == true) then
        tableauArrow4.isVisible = true
    else
        tableauArrow4.isVisible = false
    end

    -- Display the "middle" Arrows Down
    if (gameInProgress == true) then
        tableauArrow2.isVisible = true
        tableauArrow3.isVisible = true
    end

    -- Display Arrow Left
    if (#timeline > 2 and timelineIndex > 2) then
        tableauArrowLeft.isVisible = true
    else
        tableauArrowLeft.isVisible = false --!!
    end 

    -- Display Arrow Right
    if (#timeline > 2 and timelineIndex < #timeline -1) then
        tableauArrowRight.isVisible = true
    else
        tableauArrowRight.isVisible = false --!!
    end 

    local timelineSize
    if (gameInProgress) then
     timelineSize = #timeline
    else
     timelineSize = #timeline - 1
    end
    labelTimelineSize.text = timelineSize.. " carta(s)"
    timelineGroup.parent:insert( timelineGroup )
end

function restartGame()
    print("*** GAME RE-START ***")
    gameoverGroup.isVisible = false
    gameInProgress = true
    lbAction = utils.swapImage(lbAction, "Images/lbCartaInicial.png", 380, 50 , activeCardGroup)
    labelTimelineSize.text = ""
    utils.fitImage(lbAction, 200, 90, false)
    timelineGroup.isVisible = true
    tableauArrow0.isVisible = true
    tableauArrow1.isVisible = false
    tableauArrow2.isVisible = false
    tableauArrow3.isVisible = false
    tableauArrow4.isVisible = false
    tableauArrowLeft.isVisible = false
    tableauArrowRight.isVisible = false
    tableauCard1.isVisible = false
    tableauCard2.isVisible = false
    tableauCard3.isVisible = false
    tableauCard4.isVisible = false
    tableauCard5.isVisible = false
    tableauCardYear1.isVisible = false
    tableauCardYear2.isVisible = false
    tableauCardYear3.isVisible = false
    tableauCardYear4.isVisible = false
    tableauCardYear5.isVisible = false
    timeline = {}
    timelineIndex = 1
    deck = loadDeck()
    dealCard(true)
    clockText.text = "00:"..MAX_SECONDS_TIMER
    clockText.isVisible = false
end

local function loginHandler( event )
    if not event.isError then
        if (  event.phase == "logged in" ) then
            submitScore(highScore)
        end
    else
        print("ERROR EN EL LOGIN DE SCREEN-GAME: ".. event.errorMessage)

    end    
end

local function submitScoreListener( event )

    print("---> LLEGUE AL LISTENER DEL SubmitScore")
 
    -- Google Play Games Services score submission
    if ( globalData.gpgs ) then
 
        if not event.isError then
            local isBest = nil
            if ( event.scores["daily"].isNewBest ) then
                isBest = "diario"
            elseif ( event.scores["weekly"].isNewBest ) then
                isBest = "semanal"
            elseif ( event.scores["all time"].isNewBest ) then
                isBest = "de todos los tiempos"
            end
            if isBest then
                -- Congratulate player on a high score
                -- local message = "Nuevo record " .. isBest .. "!"
                -- native.showAlert( "Congratulations", message, { "OK" } )
            else
                -- Encourage the player to do better
                -- native.showAlert( "Sorry.", "Better luck next time!", { "OK" } )
            end
        end
    
    end
end

local function submitScore( score )

    print("---> A PUNTO DE MANDAR EL SCORE")
    if ( globalData.gpgs ) then
        -- Submit a score to Google Play Games Services
        globalData.gpgs.leaderboards.submit(
        {
            leaderboardId = "CgkIl_HAoI0OEAIQAQ",
            score = score,
            listener = submitScoreListener
        })
    end
end

function endGame(isDeckEmpty, isTimerEmpty, pos)
        --End Game
        print("*** GAME END ***")
        gameInProgress = false
        if (pos >0) then timeline[pos].isValid = false end
        tableauArrow1.isVisible = false
        tableauArrow2.isVisible = false
        tableauArrow3.isVisible = false
        tableauArrow4.isVisible = false
        activeCard = nil
        timelineSize = 0
        if (composer.getVariable("isRankedGame")) then timer.pause( countDownTimer ) end

        -- Es High Score?
        local score = #timeline -1
        if ( (score) > tonumber(highScore) )  then saveHighScore(score) end         

    if (composer.getVariable("isRankedGame")) then
        if (globalData.gpgs) then
            if (globalData.gpgs.isConnected()) then
                submitScore(score)
            else
                highScore = score
                globalData.gpgs.login( { userInitiated=true, listener=loginHandler } )
            end
        else
        end
    end

        if (isDeckEmpty) then
            timelineSize = #timeline
        else
            timelineSize = #timeline - 1
        end

        if (composer.getVariable("enableSound")) then audio.play( soundTable["failSound"] ) end

        local options = {
            effect = "fromTop",
            time = 500,
            isModal = true
        }
        composer.setVariable("timelineSize", timelineSize )
        showGameOverScreen(isDeckEmpty, isTimerEmpty)

end

function startGame()
    print("*** GAME START ***")
    getCurrentHighScore()
    gameInProgress = true
    activeCardImage:removeEventListener("tap", startGame)    
    lbAction = utils.swapImage(lbAction, "Images/lbUbica.png", 380, 50 , activeCardGroup)
    utils.fitImage(lbAction, 200, 90, false)
    tableauArrow0.isVisible = false
    tableauTooltip0.isVisible = false
    table.insert(timeline,activeCard)
    dealCard(false)
    if (composer.getVariable("isRankedGame")) then clockText.isVisible = true else clockText.isVisible = false end
    drawTableau()
end

local function checkTimeline(pos, relPos)
    local error = false

    if (pos > 1 ) then
        if (timeline[pos].year < timeline[pos-1].year) then
            error = true
        end
    end

    if (pos < #timeline) then
        if (timeline[pos].year > timeline[pos+1].year) then
            error = true
        end
    end

    if (error == true)
    then
        endGame(true, false, pos)
    else
        dealCard()
        if (composer.getVariable("enableSound")) then audio.play( soundTable["okSound"] ) end
        
    end
    drawTableau()
end

local function arrowLeftHandler( event )
    if ( event.phase == "ended") then
        local dx = timelineIndex
        if (dx >= 5) then pageLeft(4) end
        if (dx == 4) then pageLeft(3) end
        if (dx == 3) then pageLeft(2) end
        if (dx == 2) then pageLeft(1) end
    end
end

local function arrowRightHandler( event )
    if ( event.phase == "ended") then
        local dx = #timeline - timelineIndex
        if (dx >= 5) then pageRight(4) end
        if (dx == 4) then pageRight(3) end
        if (dx == 3) then pageRight(2) end
        if (dx == 2) then pageRight(1) end
    end
end


local function insertActiveCardInTimeline( event )  
    local pos = event.target.relPos
    local isSecondTap = event.target.isSecondTap
    local insertIntoIndex = nil

    clockText.isVisible = false

    if ( (isSecondTap == true) or (composer.getVariable("confirmPlacement") == false)) then
        if (pos == 'A') then
            tableauArrow1.isSecondTap = false
            tableauArrow1:setFillColor(1,1,1)
            insertIntoIndex = timelineIndex - 1
            timelineIndex = timelineIndex + 1
        end
        if (pos == 'B') then
            tableauArrow2.isSecondTap = false
            tableauArrow2:setFillColor(1,1,1)
            insertIntoIndex = timelineIndex 
            timelineIndex = timelineIndex + 1
        end
        if (pos == 'D') then
            tableauArrow3.isSecondTap = false
            tableauArrow3:setFillColor(1,1,1)
            insertIntoIndex = timelineIndex + 1
        end
        if (pos == 'E') then
            tableauArrow4.isSecondTap = false
            tableauArrow4:setFillColor(1,1,1)
            insertIntoIndex = timelineIndex + 2
        end

        table.insert(timeline, insertIntoIndex, activeCard)

        checkTimeline(insertIntoIndex, event.target.relPos)
    else
        if (pos == 'A') then
            tableauArrow1.isSecondTap = true
            tableauArrow2.isSecondTap = false
            tableauArrow3.isSecondTap = false
            tableauArrow4.isSecondTap = false
            tableauArrow1:setFillColor(0.87 , 0.75 , 0.59)
            tableauArrow2:setFillColor(1 , 1 , 1)
            tableauArrow3:setFillColor(1 , 1 , 1)
            tableauArrow4:setFillColor(1 , 1 , 1)
        end
        if (pos == 'B') then
            tableauArrow1.isSecondTap = false
            tableauArrow2.isSecondTap = true
            tableauArrow3.isSecondTap = false
            tableauArrow4.isSecondTap = false
            tableauArrow1:setFillColor(1 , 1 , 1)
            tableauArrow2:setFillColor(0.87 , 0.75 , 0.59)
            tableauArrow3:setFillColor(1 , 1 , 1)
            tableauArrow4:setFillColor(1 , 1 , 1)
        end
        if (pos == 'D') then
            tableauArrow1.isSecondTap = false
            tableauArrow2.isSecondTap = false
            tableauArrow3.isSecondTap = true
            tableauArrow4.isSecondTap = false
            tableauArrow1:setFillColor(1 , 1 , 1)
            tableauArrow2:setFillColor(1 , 1 , 1)
            tableauArrow3:setFillColor(0.87 , 0.75 , 0.59)
            tableauArrow4:setFillColor(1 , 1 , 1)
        end
        if (pos == 'E') then
            tableauArrow1.isSecondTap = false
            tableauArrow2.isSecondTap = false
            tableauArrow3.isSecondTap = false
            tableauArrow4.isSecondTap = true
            tableauArrow1:setFillColor(1 , 1 , 1)
            tableauArrow2:setFillColor(1 , 1 , 1)
            tableauArrow3:setFillColor(1 , 1 , 1)
            tableauArrow4:setFillColor(0.87 , 0.75 , 0.59)
        end
    end
end


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 loadDeck = function()
    local lfs = require ( "lfs" )
    local json = require( "json" )
    local contents
    local t
    local fullDeck = {}
    local cardVolumes = {}

    path = system.pathForFile( "data.db", system.DocumentsDirectory )
    local db = sqlite3.open( path )

    if (composer.getVariable("includeVolumen1") == true) then table.insert(cardVolumes, "1") end
    if (composer.getVariable("includeVolumen2") == true) then table.insert(cardVolumes, "2") end
    if (composer.getVariable("includeVolumen3") == true) then table.insert(cardVolumes, "3") end
    if (composer.getVariable("includeVolumen4") == true) then table.insert(cardVolumes, "4") end
    if (composer.getVariable("includeVolumenX") == true) then table.insert(cardVolumes, "X") end
    -- table.insert(cardVolumes, "1")
    -- table.insert(cardVolumes, "2")
    -- table.insert(cardVolumes, "3")
    -- table.insert(cardVolumes, "4")
    -- table.insert(cardVolumes, "X")

    -- Card Loading
    for k,volume in pairs(cardVolumes) do       
            -- Read from DB
            print("Cargo las cartas del "..volume)
            for row in db:nrows("SELECT * FROM cartas WHERE vol='"..volume.."' AND unlocked ='Y'") do
                table.insert(fullDeck, row)
            end         
    end

    db:close()

    -- Card Shuffling
   math.randomseed( os.time() )
   if ( type(fullDeck) ~= "table" ) then
        print( "WARNING: shuffleTable() function expects a table" )
        return false
    end
 
    local j
 
    for i = #fullDeck, 2, -1 do
        j = math.random( i )
        fullDeck[i], fullDeck[j] = fullDeck[j], fullDeck[i]
    end

    -- Add new column "isValid" with default value "true"
    for k,v in ipairs(fullDeck) do
        v.isValid=true
    end

    return fullDeck

 end

local function gotoMenu ( event )
    if ( event.action == "clicked" ) then
        local i = event.index
        if ( i == 1 ) then
            Runtime:removeEventListener( "key", globalEventListener )
            --restartGame()
            activeCardGroup.isVisible = false
            timelineGroup.isVisible = false   
            gameoverGroup.isVisible = false      
            if (composer.getVariable("isRankedGame")) then timer.cancel( countDownTimer ) end
            composer.gotoScene("screen-menu") 
        end
    end    
end

 local function showMenu()
    print("showMenu")
    native.showAlert( "Menu", "Tu partida actual se cancelará. ¿Estás seguro que deseas salir?", { "OK", "Cancelar" }, gotoMenu )
 end

globalEventListener = function( event )
    if ( event.keyName == "back" ) then
        if (event.phase == "up") then
          showMenu( )
          return true
        end
    end        
end

Runtime:addEventListener( "key", globalEventListener )

 local function updateTime( event )
 
    -- Decrement the number of seconds
    secondsLeft = secondsLeft - 1

    if (secondsLeft <= 5) then
        clockText:setFillColor( 0.7, 0, 0 )
    else
        clockText:setFillColor( 1, 1, 1 )
    end
 
    -- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( secondsLeft / 60 )
    local seconds = secondsLeft % 60
 
    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
     
    -- Update the text object
    clockText.text = timeDisplay
    clockText.isVisible = true

    if (secondsLeft <= 0) then
        endGame(false, true, 0)
    end
end

local function prepareTableau()

    debugTableauVisibilityFlag = false

    clockText = display.newText( "00:"..MAX_SECONDS_TIMER, rightSide - 75, 20, "FjallaOne-Regular", 24 )
    clockText:setFillColor( 1, 1, 1 )
    clockText.isVisible = false
    activeCardGroup:insert( clockText )

    --[[ Modal Fin Juego ]]
    gameoverGroup.height = totalHeight
    gameoverGroup.width = totalWidth
    local box = display.newImage( "Images/box-gameover.png", totalWidth - 20, 30 )
    box.anchorX = 0.5
    box.anchorY = 0.5
    box.x = centerX
    box.y = centerY - 70
    utils.fitImage(box, totalWidth - 20, totalHeight, true) 
    box:addEventListener("tap", restartGame)
    gameoverGroup:insert( box )

    local options1 = 
            {
                text = "aaa",
                x = centerX,
                y = centerY - 110,
                width = totalWidth /2,
                font = "FjallaOne-Regular",
                fontSize = 28
            }
    boxGameOverText = display.newText( options1 )
    boxGameOverText:setFillColor( 0, 0, 0 )
    gameoverGroup:insert( boxGameOverText )

   local options2 = 
            {
                text = "bbb",
                x = centerX,
                y = centerY - 80,
                width = totalWidth /2,
                font = "FjallaOne-Regular",
                fontSize = 16
            }
    boxGameOverSubtext = display.newText( options2 )
    boxGameOverSubtext:setFillColor( 0.43, 0.37, 0.28 )
    gameoverGroup:insert( boxGameOverSubtext )

    local options3= 
            {
                text = "ccc",
                x = centerX,
                y = centerY - 15,
                width = totalWidth /2,
                font = "FjallaOne-Regular",
                fontSize = 12
            }
    boxGameOverSubtext2 = display.newText( options3 )
    boxGameOverSubtext2:setFillColor( 0.43, 0.37, 0.28 )
    gameoverGroup:insert( boxGameOverSubtext2 )

    unlockedCard = display.newImageRect( activeCardGroup, "Images/Cartas/locked.jpg", 90, 125)
    unlockedCard.anchorX = 1
    unlockedCard.anchorY = 0
    unlockedCard.x = rightSide - 50
    unlockedCard.y = topSide + 25
    unlockedCard:setStrokeColor( 0.43, 0.37, 0.28 )
    unlockedCard.strokeWidth = 5
    gameoverGroup:insert( unlockedCard )  

    unlockedCardBox = display.newRoundedRect(box.x, centerY - 35, 450, 50, 10 ) 
    unlockedCardBox:setFillColor( 0.43, 0.37, 0.28 )  
    gameoverGroup:insert( unlockedCardBox ) 

    local options3 = 
            {
                text = "¡Ganaste una nueva carta!",
                x = centerX+100,
                y = centerY - 45,
                width = totalWidth /2,
                font = "FjallaOne-Regular",
                fontSize = 16,
                align = 'right'
            }
    boxGameOverUnlockedText = display.newText( options3 )
    boxGameOverUnlockedText.anchorX = 1
    boxGameOverUnlockedText:setFillColor( 1, 1, 1 )
    gameoverGroup:insert( boxGameOverUnlockedText )

    local options4 = 
            {
                text = "NNN Fue agregada a tu colección.",
                x = centerX+100,
                y = centerY - 25,
                width = totalWidth - 80,
                font = "FjallaOne-Regular",
                fontSize = 11,
                align = 'right'
            }
    boxGameOverUnlockedSubtext = display.newText( options4 )
    boxGameOverUnlockedSubtext.anchorX = 1
    boxGameOverUnlockedSubtext:setFillColor( 1, 1, 1 )
    gameoverGroup:insert( boxGameOverUnlockedSubtext )    

    gameoverGroup.parent:insert( gameoverGroup )
    gameoverGroup.isVisible = false -- Cambiar (!)

    logoSAImg = display.newImageRect( activeCardGroup, "Images/logoSA-sm.png", 45,  45 )
    logoSAImg.anchorX = 0
    logoSAImg.anchorY = 0
    logoSAImg.x = leftSide+5
    logoSAImg.y = 10
    logoSAImg:addEventListener('tap', showMenu)
    activeCardGroup:insert( logoSAImg )
    
    lbAction = display.newImageRect(activeCardGroup, "Images/lbCartaInicial.png", 380,  50 )
    utils.fitImage(lbAction, 200, 90, false)
    lbAction.anchorX = 0
    lbAction.x = leftSide + logoSAImg.width + 10
    lbAction.y = topSide + 30

    activeCardTitle = display.newText(activeCardGroup, "Title Title Title" , leftSide +20 ,topSide + 100, display.contentWidth * 0.85, 70,"FjallaOne-Regular.ttf", 20, center )
    activeCardTitle.anchorX = 0
    activeCardTitle:setFillColor( 1, 1, 1 )

    activeCardFlavourText = display.newText(activeCardGroup, "txttxttxttxttxttxttxttxt", leftSide + 20, topSide + 125, 350, 0, native.systemFont, 11 )
    activeCardFlavourText.anchorX = 0
    activeCardFlavourText.anchorY = 0
    activeCardFlavourText:setFillColor( 1, 1, 1 )

    labelTimelineSize = display.newText(activeCardGroup, "", 20, display.actualContentHeight-10, native.systemFont, 8 )
    labelTimelineSize.anchorX = 1
    labelTimelineSize.x = totalWidth -100
    labelTimelineSize:setFillColor( 0.9, 0.9, 0.9 )

    activeCardImage = display.newImageRect(activeCardGroup, "Images/Cartas/0.jpg",120, 167 )
    utils.fitImage(activeCardImage, 200, 280, false)
    activeCardImage.anchorX = 0
    activeCardImage.anchorY = 0
    activeCardImage.x =rightSide - 130
    activeCardImage.y = 30
    activeCardGroup:insert( activeCardImage )

    activeCardPip = display.newCircle( activeCardGroup, activeCardImage.x + activeCardImage.width - 21, activeCardImage.y + activeCardImage.height - 25, 6 )
    activeCardPip:setFillColor( 1 )
    activeCardPip.strokeWidth = 2
    activeCardPip:setStrokeColor( 0.58, 0.52, 0.39 )
    activeCardGroup:insert( activeCardPip )

    local tableauTimeline = display.newRoundedRect( timelineGroup, leftSide + 10, bottomSide-70, totalWidth - 20, 10, 20 )
    tableauTimeline.anchorX = 0
    tableauTimeline.anchorY = 0

    -- Dummy Cards, to be removed
  tableauCard1 = display.newImageRect( timelineGroup, "Images/Cartas/0.jpg", 50,  70 )
  tableauCard1.strokeWidth = 3
  tableauCard1:setStrokeColor(0.58, 0.52, 0.39 )
  tableauCard1.x = ( totalWidth * 2/12) + leftSide
  tableauCard1.y = display.actualContentHeight - 70
  tableauCard1.order = 1
  tableauCard1.isVisible = debugTableauVisibilityFlag
  tableauCard1.anchorX = 0.5
  tableauCardTitle1 = display.newText(timelineGroup, 'NNN2',( totalWidth * 1/6 ) + leftSide, display.actualContentHeight*5/6-70,  native.systemFont, 10);
  tableauCardTitle1:setFillColor(1,1,1)
  tableauCardTitle1.isVisible = debugTableauVisibilityFlag
  tableauCardYear1 = display.newText(timelineGroup, 'NNN',( totalWidth * 1/6 ) + leftSide, display.actualContentHeight - 25, native.systemFont, 14);
  tableauCardYear1:setFillColor(1,1,1)
  tableauCardYear1.isVisible = debugTableauVisibilityFlag
  tableauCard1:addEventListener( "touch", timelineCardHandle )

  tableauCard2 = display.newImageRect( timelineGroup, "Images/Cartas/0.jpg", 50,  70 )
  tableauCard2.strokeWidth = 3
  tableauCard2:setStrokeColor(0.58, 0.52, 0.39 )
  tableauCard2.x = ( totalWidth * 4/12 ) + leftSide
  tableauCard2.y = display.actualContentHeight - 70
  tableauCard2.order = 2
  tableauCard2.isVisible = debugTableauVisibilityFlag
  tableauCard2.anchorX = 0.5
  tableauCardTitle2 = display.newText(timelineGroup, 'NNN2',( totalWidth * 2/6 ) + leftSide,display.actualContentHeight*5/6-70,  native.systemFont, 10);
  tableauCardTitle2:setFillColor(1,1,1)
  tableauCardTitle2.isVisible = debugTableauVisibilityFlag
  tableauCardYear2 = display.newText(timelineGroup, 'NNN',( totalWidth * 2/6 ) + leftSide,display.actualContentHeight - 25, native.systemFont, 14);
  tableauCardYear2:setFillColor(1,1,1)
  tableauCardYear2.isVisible = debugTableauVisibilityFlag
  tableauCard2:addEventListener( "touch", timelineCardHandle )

  tableauCard3 = display.newImageRect( timelineGroup, "Images/Cartas/0.jpg", 50,  70 )
  tableauCard3.strokeWidth = 3
  tableauCard3:setStrokeColor(0.58, 0.52, 0.39 )
  tableauCard3.x =( totalWidth * 6/12 ) + leftSide
  tableauCard3.y = display.actualContentHeight - 70
  tableauCard3.order = 3
  tableauCard3.isVisible = debugTableauVisibilityFlag
  tableauCard3.anchorX = 0.5
  tableauCardTitle3 = display.newText(timelineGroup, 'NNN2',( totalWidth * 3/6 ) + leftSide,display.actualContentHeight*5/6-70,  native.systemFont, 10);
  tableauCardTitle3:setFillColor(1,1,1)
  tableauCardTitle3.isVisible = debugTableauVisibilityFlag
  tableauCardYear3 = display.newText(timelineGroup, 'NNN',( totalWidth * 3/6 ) + leftSide,display.actualContentHeight -25, native.systemFont, 14);
  tableauCardYear3:setFillColor(1,1,1)
  tableauCardYear3.isVisible = debugTableauVisibilityFlag
  tableauCard3:addEventListener( "touch", timelineCardHandle )

  tableauCard4 = display.newImageRect( timelineGroup, "Images/Cartas/0.jpg", 50,  70 )
  tableauCard4.strokeWidth = 3
  tableauCard4:setStrokeColor(0.58, 0.52, 0.39 )
  tableauCard4.x = ( totalWidth * 8/12) + leftSide
  tableauCard4.y = display.actualContentHeight - 70
  tableauCard4.order = 4
  tableauCard4.isVisible = debugTableauVisibilityFlag
  tableauCard4.anchorX = 0.5
  tableauCardTitle4 = display.newText(timelineGroup, 'NNN2',( totalWidth * 4/6 ) + leftSide,display.actualContentHeight*5/6-70,  native.systemFont, 10);
  tableauCardTitle4:setFillColor(1,1,1)
  tableauCardTitle4.isVisible = debugTableauVisibilityFlag
  tableauCardYear4 = display.newText(timelineGroup, 'NNN',( totalWidth * 4/6 ) + leftSide,display.actualContentHeight -25 , native.systemFont, 14);
  tableauCardYear4:setFillColor(1,1,1)
  tableauCardYear4.isVisible = debugTableauVisibilityFlag
  tableauCard4:addEventListener( "touch", timelineCardHandle )

  tableauCard5 = display.newImageRect( timelineGroup, "Images/Cartas/0.jpg", 50,  70 )
  tableauCard5.strokeWidth = 3
  tableauCard5:setStrokeColor(0.58, 0.52, 0.39 )
  tableauCard5.x = ( totalWidth * 10/12 ) + leftSide
  tableauCard5.y = display.actualContentHeight - 70
  tableauCard5.order = 5
  tableauCard5.isVisible = debugTableauVisibilityFlag
  tableauCard5.anchorX = 0.5
  tableauCardTitle5 = display.newText(timelineGroup, 'NNN2', ( totalWidth * 5/6 ) + leftSide,display.actualContentHeight*5/6-70,  native.systemFont, 10);
  tableauCardTitle5:setFillColor(1,1,1)
  tableauCardTitle5.isVisible = debugTableauVisibilityFlag
  tableauCardYear5 = display.newText(timelineGroup, 'NNN', ( totalWidth * 5/6 ) + leftSide,display.actualContentHeight - 25, native.systemFont, 14);
  tableauCardYear5:setFillColor(1,1,1)
  tableauCardYear5.isVisible = debugTableauVisibilityFlag
  tableauCard5:addEventListener( "touch", timelineCardHandle )

    -- Down Arrows
  tableauArrow0 = display.newCircle( timelineGroup,( totalWidth * 6/12 ) + leftSide , display.actualContentHeight-65, 15 )
  tableauArrow0.relPos = '-'
  tableauArrow0.isSecondTap = false
  tableauArrow0.isVisible = true
  tableauArrow0:addEventListener("tap", startGame)
  tableauTooltip0 = display.newText(timelineGroup, '¡Tocá aquí!',( totalWidth * 6/12 ) + leftSide, display.actualContentHeight-90,  native.systemFont, 14);
  tableauTooltip0:setFillColor(0.87, 0.75, 0.59)

  tableauArrow1 = display.newCircle( timelineGroup, ( totalWidth * 3/12 ) + leftSide , display.actualContentHeight-65, 15 )
  tableauArrow1.relPos = 'A'
  tableauArrow1.isSecondTap = false
  tableauArrow1.isVisible = debugTableauVisibilityFlag
  tableauArrow1:addEventListener('tap',insertActiveCardInTimeline)

  tableauArrow2 = display.newCircle( timelineGroup, ( totalWidth * 5/12 ) + leftSide , display.actualContentHeight-65, 15 )
  tableauArrow2.relPos = 'B'
  tableauArrow2.isSecondTap = false
  tableauArrow2.isVisible = debugTableauVisibilityFlag
  tableauArrow2:addEventListener('tap',insertActiveCardInTimeline)

  tableauArrow3 = display.newCircle( timelineGroup, ( totalWidth * 7/12 ) + leftSide ,  display.actualContentHeight-65, 15 )
  tableauArrow3.relPos = 'D'
  tableauArrow3.isSecondTap = false
  tableauArrow3.isVisible = debugTableauVisibilityFlag
  tableauArrow3:addEventListener('tap',insertActiveCardInTimeline)

  tableauArrow4 = display.newCircle( timelineGroup, ( totalWidth * 9/12 ) + leftSide , display.actualContentHeight-65, 15 )
  tableauArrow4.relPos = 'E'
  tableauArrow4.isSecondTap = false
  tableauArrow4.isVisible = debugTableauVisibilityFlag
  tableauArrow4:addEventListener('tap',insertActiveCardInTimeline)

  tableauArrowLeft = display.newPolygon(timelineGroup, leftSide + 20, display.actualContentHeight-65, {
        5,display.actualContentHeight-65 , 
        45,display.actualContentHeight-50 , 
        45,display.actualContentHeight-80
    })
  tableauArrowLeft.isVisible = debugTableauVisibilityFlag
  tableauArrowLeft:setFillColor(1,1,1)
  tableauArrowLeft:addEventListener('touch', arrowLeftHandler)  

  tableauArrowRight = display.newPolygon(timelineGroup, rightSide - 20, display.actualContentHeight-65, { 
        totalWidth - 5,display.actualContentHeight-65 , 
        totalWidth - 45,display.actualContentHeight-50,  
        totalWidth - 45,display.actualContentHeight-80
    })
  tableauArrowRight.isVisible = debugTableauVisibilityFlag
  tableauArrowRight:setFillColor(1,1,1)
  tableauArrowRight:addEventListener('touch', arrowRightHandler)  

  timelineGroup:addEventListener("touch", timelineCardHandle)

  activeCardGroup.isVisible = false
  timelineGroup.isVisible = true
end

function displayCard(isInitial)
    activeCardTitle.text = ">> "..activeCard.title
    activeCardFlavourText.text = activeCard.text

    -- Check if Card Image exists. If not, replace with default image
    if (utils.file_exists("Images/Cartas/"..activeCard.image) == false) then
        activeCard.image = "0.jpg"
    end

    activeCardImage = utils.swapImage(activeCardImage, "Images/Cartas/"..activeCard.image, 120, 167, activeCardGroup, 0)
    activeCardImage.strokeWidth = 5
    activeCardImage:setStrokeColor(0.58, 0.52, 0.4 )

    if (isInitial) then 
        activeCardTitle.text = activeCardTitle.text.." ("..activeCard.year..")" 
    end

    -- CHANGE Pip color -- 
    if (activeCard.vol == "1") then 
        activeCardPip:setFillColor( 0 , 0.5 , 1 ) 
    end -- 0.72 , 0.84 , 0.94     
    if (activeCard.vol == "2") then 
        activeCardPip:setFillColor( 0 , 0.5 , 0 ) 
    end -- 0.26 , 0.71 , 0.70
    if (activeCard.vol == "3") then 
        activeCardPip:setFillColor( 1 , 0 , 0 ) 
    end -- 0.75 , 0.50 , 0.51
    if (activeCard.vol == "4") then 
        activeCardPip:setFillColor( 0.99 , 0.94 , 0 ) 
    end -- 0.75 , 0.50 , 0.51
    if (activeCard.vol == "5") then 
        activeCardPip:setFillColor( 0, 1, 0 ) 
    end
    if (activeCard.vol == "X") then 
        activeCardPip:setFillColor( 0.9, 0.9, 0.9 ) 
    end
    activeCardGroup:insert( activeCardPip )
    activeCardGroup.isVisible = true
end

function dealCard(isInitialCard)
    if (#deck > 0) then
      local card = deck[1]
      table.remove( deck, 1 )
      activeCard =  card
      displayCard(isInitialCard)
    else
        endGame(true,false,0)
    end

    if (composer.getVariable("isRankedGame")) then
        if (isInitialCard) then
            countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
            timer.pause( countDownTimer )
            clockText.isVisible = false
        else
            secondsLeft = MAX_SECONDS_TIMER
            timer.cancel( countDownTimer )
            countDownTimer = timer.performWithDelay( 1000, updateTime, secondsLeft )
        end
    else
        clockText.isVisible = false
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    deck = loadDeck()
    prepareTableau()
    dealCard(true)
    timelineIndex =  1
    
end

 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
     
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        local backgroundImage = display.newImage(sceneGroup, "Images/background.jpg" )
        backgroundImage.anchorX = 0.5
        backgroundImage.anchorY = 0.5
        backgroundImage.x = centerX
        backgroundImage.y = centerY
        backgroundImage.height = totalHeight
        backgroundImage.width = totalWidth
        sceneGroup:insert( backgroundImage )
 
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