local orienteering = {}
orienteering.playerhuds = {}

-- Displays height (Y)
minetest.register_tool("orienteering:altimeter", {
	description = "Altimeter",
	wield_image = "orienteering_altimeter.png",
	inventory_image = "orienteering_altimeter.png",
})

-- Displays X and Z coordinates
minetest.register_tool("orienteering:triangulator", {
	description = "Triangulator",
	wield_image = "orienteering_triangulator.png",
	inventory_image = "orienteering_triangulator.png",
})

-- Displays player yaw and can calculate yaw difference between 2 points
minetest.register_tool("orienteering:compass", {
	description = "Compass",
	wield_image = "orienteering_compass_wield.png",
	inventory_image = "orienteering_compass_inv.png",
})

-- Displays player pitch and can calculate pitch difference between 2 points
minetest.register_tool("orienteering:sextant", {
	description = "Sextant",
	wield_image = "orienteering_sextant_wield.png",
	inventory_image = "orienteering_sextant_inv.png",
})

-- Displays game time
minetest.register_tool("orienteering:watch", {
	description = "Watch",
	wield_image = "orienteering_watch.png",
	inventory_image = "orienteering_watch.png",
})

-- Displays speed
minetest.register_tool("orienteering:speedometer", {
	description = "Speedometer",
	wield_image = "orienteering_speedometer_wield.png",
	inventory_image = "orienteering_speedometer_inv.png",
})

-- Enables minimap
minetest.register_tool("orienteering:automapper", {
	description = "Automapper",
	wield_image = "orienteering_automapper_wield.png",
	inventory_image = "orienteering_automapper_inv.png",
})

-- Displays X,Y,Z coordinates, height, speed, yaw and game time
minetest.register_tool("orienteering:gps", {
	description = "GPS device",
	wield_image = "orienteering_gps_wield.png",
	inventory_image = "orienteering_gps_inv.png",
})



function update_automapper(player)
	local inv = player:get_inventory()
	if inv:contains_item("main", "orienteering:automapper") then
		player:hud_set_flags({minimap = true})
	else
		player:hud_set_flags({minimap = false})
	end
end

function init_hud(player)
	update_automapper(player)
	local name = player:get_player_name()
	orienteering.playerhuds[name] = {}
	local tablenames = { "pos", "angles", "time", "speed" }
	for i=1, #tablenames do
		orienteering.playerhuds[name][tablenames[i]] = player:hud_add({
			hud_elem_type = "text",
			text = "",
			position = { x = 0.5, y = 0.001 },
			offset = { x = 0, y = 0+20*i },
			alignment = { x = 0, y = 0 },
			number = 0xFFFFFF,
			scale= { x = 100, y = 20 },
		})
	end
end

function update_hud_displays(player)
	local inv = player:get_inventory()
	local gps, altimeter, triangulator, compass, sextant, watch, speedometer
	if inv:contains_item("main", "orienteering:gps") then
		gps = true
	end
	if inv:contains_item("main", "orienteering:altimeter") then
		altimeter = true
	end
	if inv:contains_item("main", "orienteering:triangulator") then
		triangulator = true
	end
	if inv:contains_item("main", "orienteering:compass") then
		compass = true
	end
	if inv:contains_item("main", "orienteering:sextant") then
		sextant = true
	end
	if inv:contains_item("main", "orienteering:watch") then
		watch = true
	end
	if inv:contains_item("main", "orienteering:speedometer") then
		speedometer = true
	end

	local str_pos, str_angles, str_time, str_speed
	local pos = vector.apply(player:getpos(), math.floor)
	if (altimeter and triangulator) or gps then
		str_pos = "Coordinates: X="..pos.x..", Y="..pos.y..", Z="..pos.z
	elseif altimeter then
		str_pos = "Height: Y="..pos.y
	elseif triangulator then
		str_pos = "Coordinates: X="..pos.x..", Z="..pos.z
	else
		str_pos = ""
	end

	local yaw = math.floor((player:get_look_yaw()-math.pi*0.5)/(2*math.pi)*360)
	local pitch = math.floor(player:get_look_pitch()/math.pi*360)
	if compass and sextant then
		str_angles = "Yaw: "..yaw..", pitch: "..pitch
	elseif compass or gps then
		str_angles = "Yaw: "..yaw
	elseif sextant then
		str_angles = "Pitch: "..yaw
	else
		str_angles = ""
	end

	local time = minetest.get_timeofday()
	if watch or gps then
		local totalminutes = time * 1440
		local hours = math.floor(totalminutes / 60)
		local minutes = math.floor(math.fmod(totalminutes, 60))
		str_time = string.format("Time: %02i:%02i", hours, minutes)
	else
		str_time = ""
	end

	if speedometer or gps then
		str_speed = ""
	else
		str_speed = ""
	end

	local name = player:get_player_name()
	player:hud_change(orienteering.playerhuds[name].pos, "text", str_pos)
	player:hud_change(orienteering.playerhuds[name].angles, "text", str_angles)
	player:hud_change(orienteering.playerhuds[name].time, "text", str_time)
	player:hud_change(orienteering.playerhuds[name].speed, "text", str_speed)
end

minetest.register_on_newplayer(init_hud)
minetest.register_on_joinplayer(init_hud)

minetest.register_on_leaveplayer(function(player)
	orienteering.playerhuds[player:get_player_name()] = nil
end)

local updatetimer = 0
minetest.register_globalstep(function(dtime)
	updatetimer = updatetimer + dtime
	if updatetimer > 0.1 then
		local players = minetest.get_connected_players()
		for i=1, #players do
			update_automapper(players[i])
			update_hud_displays(players[i])
		end
		updatetimer = updatetimer - dtime
	end
end)
