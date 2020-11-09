local json = require( "json" )
local lfs = require ( "lfs" )
local M = {}

M.doMigrate = function()

	local function migrateFile(file, db, migracion_id)

		local path = system.pathForFile( file, system.baseDirectory )
		local f, errorString = io.open( path, "r" )

		print ("[DEBUG] Procesando file:"..path)

		if not f then
		    -- Error occurred; output the cause
		    print( "[DEBUG] File error: " .. errorString )
		else
		    -- Output lines
		    for row in f:lines() do
	        	db:exec(row)
		    end
		    -- Close the file handle
		    io.close( f )
		end
		 
		f = nil

	end

    -- Creo el archivo de opciones si no existe.
    local path = system.pathForFile( "options.dat", system.DocumentsDirectory )
    local file, errorString = io.open( path, "r" )
    if not file then
        file = io.open( path, "w" )
        file:write("")
        io.close( file )
    end

    -- Abro la base de datos
    path = system.pathForFile( "data.db", system.DocumentsDirectory )
    local db = sqlite3.open( path )    

    -- DEBUGGING!!
    db:exec("DELETE FROM cartas")
    
    -- Set up the tables if they don't exist
    local tableMigraciones = [[CREATE TABLE IF NOT EXISTS migraciones(migracion INTEGER PRIMARY KEY);]]
    db:exec( tableMigraciones )
    local tableCartas = [[CREATE TABLE IF NOT EXISTS cartas(carta_id INTEGER PRIMARY KEY, vol TEXT, image TEXT, title TEXT, year TEXT, text TEXT, unlocked TEXT);]]
    db:exec( tableCartas )    

	-- Recorro los archivos de cartas
	local path = system.pathForFile( "", system.baseDirectory )

	for file in lfs.dir ( path ) do
	    if string.find( file, "cartas.db" ) then
	    	print("[DEBUG] Voy a procesar el archivo "..file)
	    	local mig = file.sub(file, file.find(file,'.') )
	        	migrateFile(file, db, mig)
	    end
	end

	db:close()

end
return M