if SERVER then
	local colors = {}
	AddCSLuaFile("sh_names.lua")
	util.AddNetworkString( "colorsettings" )
	
	if !file.Exists("colors.txt", "DATA" ) then
		file.Write("colors.txt", "")
	else
		local blarg = file.Read("colors.txt", "DATA")
		if blarg != nil then
			blarg = string.Explode("\n", blarg)
			for _, v in pairs(blarg) do
				if v != "" then
					local temp = string.Explode(" ", v )
					table.insert( colors, { temp[1], temp[2], temp[3], temp[4] } )
				end
			end
		end
	end
	
	hook.Add("PlayerInitialSpawn", "DonatorProc", function(ply)
		net.Start( "colorsettings" )
		net.WriteTable( colors )
		net.Send( ply )
	end)
	
	concommand.Add("names_colors_verify", function(ply)
		net.Start( "colorsettings" )
		net.WriteTable( colors )
		net.Send( ply )
	end)
	
	function addColor(plyid, r, g, b)
		local found = false
		local temp = ""
		
		for _, v in pairs(colors) do
			if v[1] == plyid then
				v[2] = r
				v[3] = g
				v[4] = b
				found = true
			end
		end
		
		if found == false then
			table.insert( colors, { plyid, r, g, b } )
		end
		
		for _, v in pairs(colors) do
			temp = temp..v[1].." "..v[2].." "..v[3].." "..v[4].."\n"
		end
		
		file.Write("colors.txt", temp)
		net.Start( "colorsettings" )
		net.WriteTable( colors )
		net.Broadcast()
	end
end

if CLIENT then
	local colors = {}
	
	net.Receive("colorsettings", function(length, ply)
		colors = net.ReadTable()
	end)

	hook.Add("TTTScoreboardColorForPlayer", "SBColors", function(ply)
		for k, v in pairs(colors) do
			if v[1] == ply:SteamID() then
				return Color(v[2], v[3], v[4])
			end
		end	
	end)
	
	timer.Create("verifycolortable", 5, 0, function()
		if colors[1] == nill then
			RunConsoleCommand("names_colors_verify")
		else
			timer.Remove("verifycolortable")
		end
	end)
end