local json = require( "json" )
local M = {}

M.fitImage = function( displayObject, fitWidth, fitHeight, enlarge )
	local scaleFactor = fitHeight / displayObject.height 
	local newWidth = displayObject.width * scaleFactor
	if newWidth > fitWidth then
		scaleFactor = fitWidth / displayObject.width 
	end
	if not enlarge and scaleFactor > 1 then
		return
	end
	displayObject:scale( scaleFactor, scaleFactor )
end

M.perc = function( perc, fullPixel )
	return perc * fullPixel / 100
end

M.file_exists = function(filepath)
   local result = false
   local img = display.newImage(filepath)
   if img ~= nil then                        
     display.remove(img)
     result = true
   end 
   return result
end

M.swapImage = function(oldImage, imageFile, width, height, container, order)
    if (imageFile ~= nil) then
        local newImage = display.newImageRect(container, imageFile, width, height)
        newImage.x = oldImage.x
        newImage.y = oldImage.y
        newImage.anchorX = oldImage.anchorX    
        newImage.anchorY = oldImage.anchorY
        newImage.order = order
        oldImage:removeSelf()
        oldImage = nil
        return newImage
    else    
        local newImage = display.newImageRect(container, '0.jpg', width, height)
        newImage.x = oldImage.x
        newImage.y = oldImage.y
        newImage.anchorX = oldImage.anchorX    
        newImage.anchorY = oldImage.anchorY
        newImage.order = order
        oldImage:removeSelf()
        oldImage = nil
        return newImage
    end
end

M.copyFileTo = function( filename, destination )
    assert( type(filename) == "string", "string expected for the first parameter but got " .. type(filename) .. " instead." )
    assert( type(destination) == "table", "table expected for the second paramter but bot " .. type(destination) .. " instead." )
    local sourceDBpath = system.pathForFile( filename, system.ResourceDirectory )
    -- io.open opens a file at path; returns nil if no file found
    local readHandle, errorString = io.open( sourceDBpath, "rb" )
    assert( readHandle, "Database at " .. filename .. " could not be read from system.ResourceDirectory" )
    assert( type(destination.filename) == "string", "filename should be a string, its a " .. type(destination.filename) )
    assert( type(destination.baseDir) == "userdata", "baseName should be a valid system directory" )
 
    local destinationDBpath = system.pathForFile( destination.filename, destination.baseDir )
    local writeHandle, writeErrorString = io.open( destinationDBpath, "wb" )
    assert( writeHandle, "Could not open " .. destination.filename .. " for writing." )
 
    local contents = readHandle:read( "*a" )
    local size = #(json.decode(contents))
    writeHandle:write( contents )
 
    io.close( writeHandle )
    io.close( readHandle )
    return size
end

return M