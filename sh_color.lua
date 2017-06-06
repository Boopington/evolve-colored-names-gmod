local PLUGIN = {}
PLUGIN.Title = "Color"
PLUGIN.Description = "Change your own color."
PLUGIN.Author = "Boopington"
PLUGIN.ChatCommand = "color"
PLUGIN.Usage = "[r 0-255] [g 0-255] [b 0-255]"
PLUGIN.Privileges = { "Color" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Color" ) ) then
		if args[1] == nil then
			evolve:Notify( ply, evolve.colors.red, "Invalid color." )
			return
		end
		local r = tonumber(args[1])
		local g = tonumber(args[2])
		local b = tonumber(args[3])
		
		if ( not isnumber(r) ) or ( not isnumber(g) ) or ( not isnumber(b) ) then
			evolve:Notify( ply, evolve.colors.red, "Please only use values between 0 and 255." )
			return
		end
		
		if r < 0 or r > 255 then
			evolve:Notify( ply, evolve.colors.red, "Invalid red." )
			return
		end
		
		if g < 0 or g > 255 then
			evolve:Notify( ply, evolve.colors.red, "Invalid color." )
			return
		end
		
		if b < 0 or b > 255 then
			evolve:Notify( ply, evolve.colors.red, "Invalid color." )
			return
		end
		
		addColor(ply:SteamID(), args[1], args[2], args[3])
		evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " changed their ", Color(r, g, b, 255), "color", evolve.colors.white, "." )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
end

evolve:RegisterPlugin( PLUGIN )