local composer = require( "composer" )
local utils = require( "utils" )
local os = require( "os" )
local globalData = require( "globalData" )
local licensing = require( "licensing" )
local platform = system.getInfo( "platform" )
local env = system.getInfo( "environment" )
local json = require( "json" )
local sqlite3 = require( "sqlite3" )

if ( platform == "android" and env ~= "simulator" ) then
    licensing.init( "google" )
end

native.setProperty( "androidSystemUiVisibility" , "immersiveSticky" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- Google Play License
local function licensingListener( event )
    if not ( event.isVerified ) then
        -- Failed to verify app from the Google Play store; print a message
        print( "Pirates!!!" )
    else
        print( "License OK")
    end
end

-- Handle the "applicationExit" event to close the database
local function onSystemEvent( event )
    if ( event.type == "applicationExit" ) then             
        db:close()
    end
end

local function startGame()

	system.setIdleTimer(false) -- Screen does not turn off automatically
	composer.setVariable( "sound", false)
	composer.setVariable( "includeVolumen1", true)
	composer.setVariable( "includeVolumen2", true)
	composer.setVariable( "includeVolumen3", true)
    composer.setVariable( "includeVolumen4", true)
    composer.setVariable( "includeVolumenX", true)
    composer.setVariable( "confirmPlacement", false)
	composer.setVariable( "isRankedGame", false)
	composer.setVariable( "timelineIndex", 1) -- Pointer to center card on 5-card displayed timeline

   --  timer.performWithDelay(1000, function() composer.gotoScene("screen-aaludica"); end)
   composer.gotoScene("screen-album");
end

-- start --
print("      ***************************************************     ")
if ( platform == "android" and env ~= "simulator" ) then
    licensing.verify( licensingListener )
end
composer.recycleOnSceneChange = true
startGame()