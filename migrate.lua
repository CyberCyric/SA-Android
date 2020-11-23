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

  	-- Open "data.db". If the file doesn't exist, it will be created
    path = system.pathForFile( "data.db", system.DocumentsDirectory )
    local db = sqlite3.open( path ) 
    if db then
        SQL = [[CREATE TABLE IF NOT EXISTS cartas(carta_id INTEGER PRIMARY KEY, vol TEXT, image TEXT, title TEXT, year TEXT, text TEXT, unlocked TEXT);]]
        db:exec(SQL)

		for row in db:nrows("SELECT COUNT(carta_id) AS total FROM cartas") do
			if (row.total == 0) then
				local path = system.pathForFile( "cartas.db", system.BaseDirectory )
		    	local file, errorString = io.open( path, "r" )
		    	for row in file:lines() do
			      	db:exec(row)
				end
				io.close( file )
			end
		end
    end

    db:close()
    end

return M