local orienteering = {}
orienteering.playerhuds = {}
orienteering.settings = {}
orienteering.settings.speed_unit = "m/s"
orienteering.settings.length_unit = "m"

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

-- Displays player yaw
-- TODO: calculate yaw difference between 2 points
minetest.register_tool("orienteering:compass", {
	description = "Compass",
	wield_image = "orienteering_compass_wield.png",
	inventory_image = "orienteering_compass_inv.png",
})

-- Displays player pitch
-- TODO: calculate pitch difference between 2 points
minetest.register_tool("orienteering:sextant", {
	description = "Sextant",
	wield_image = "orienteering_sextant_wield.png",
	inventory_image = "orienteering_sextant_inv.png",
})

-- Ultimate orienteering tool: Displays X,Y,Z, yaw, pitch, time, speed and enables the minimap
minetest.register_tool("orienteering:quadcorder", {
	description = "Quadcorder",
	wield_image = "orienteering_quadcorder.png",
	wield_scale = { x=1, y=1, z=3.5 },
	inventory_image = "orienteering_quadcorder.png",
})

-- Displays game time
minetest.register_tool("orienteering:watch", {
	description = "Watch",
	wield_image = "orienteering_watch.png",
	inventory_image = "orienteering_watch.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		if orienteering.playerhuds[name].twelve then
			orienteering.playerhuds[name].twelve = false
		else
			orienteering.playerhuds[name].twelve = true
		end
		update_hud_displays(user)
	end,
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
	wield_scale = { x=1, y=1, z=2 },
	inventory_image = "orienteering_automapper_inv.png",
})

-- Displays X,Y,Z coordinates, yaw and game time
minetest.register_tool("orienteering:gps", {
	description = "GPS device",
	wield_image = "orienteering_gps_wield.png",
	wield_scale = { x=1, y=1, z=2 },
	inventory_image = "orienteering_gps_inv.png",
})

if minetest.get_modpath("default") ~= nil then
	-- Register crafts
	minetest.register_craft({
		output = "orienteering:altimeter",
		recipe = {
			{"default:copper_ingot"}, 
			{"default:copper_ingot"}, 
			{"default:copper_ingot"}, 
		}
	})
	minetest.register_craft({
		output = "orienteering:triangulator",
		recipe = {
			{"", "default:bronze_ingot", ""}, 
			{"default:bronze_ingot", "", "default:bronze_ingot"}, 
		}
	})
	minetest.register_craft({
		output = "orienteering:sextant",
		recipe = {
			{"", "default:gold_ingot", ""}, 
			{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}, 
		}
	})
	minetest.register_craft({
		output = "orienteering:compass",
		recipe = {
			{"", "default:copper_ingot", ""}, 
			{"default:copper_ingot", "group:stick", "default:copper_ingot"}, 
			{"", "default:copper_ingot", ""}, 
		}
	})
	minetest.register_craft({
		output = "orienteering:speedometer",
		recipe = {
			{"", "default:steel_ingot", ""}, 
			{"default:steel_ingot", "group:stick", "default:steel_ingot"}, 
			{"", "default:steel_ingot", ""}, 
		}
	})
	minetest.register_craft({
		output = "orienteering:automapper",
		recipe = {
			{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"},
			{"default:mese_crystal", "default:obsidian_shard", "default:mese_crystal"},
			{"default:gold_ingot", "default:gold_ingot", "default:gold_ingot"}
		}
	})
	minetest.register_craft({
		output = "orienteering:gps",
		recipe = {
			{ "default:gold_ingot", "orienteering:triangulator", "default:gold_ingot" },
			{ "orienteering:compass", "default:bronze_ingot", "orienteering:watch" },
                        { "default:steel_ingot", "orienteering:altimeter", "default:steel_ingot" }
		}
	})
	minetest.register_craft({
		output = "orienteering:quadcorder",
		recipe = {
			{ "default:gold_ingot", "default:gold_ingot", "default:gold_ingot" },
			{ "orienteering:speedometer", "default:diamond", "orienteering:automapper", },
                        { "orienteering:sextant", "default:diamond", "orienteering:gps" }
		}
	})
	minetest.register_craft({
		output = "orienteering:watch",
		recipe = {
			{ "default:copper_ingot" },
			{ "default:glass" },
			{ "default:copper_ingot" }
		}
	})

end



function update_automapper(player)
	local inv = player:get_inventory()
	if inv:contains_item("main", "orienteering:automapper") or inv:contains_item("main", "orienteering:quadcorder") then
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
	orienteering.playerhuds[name].twelve = false
end

function update_hud_displays(player)
	local name = player:get_player_name()
	local inv = player:get_inventory()
	local gps, altimeter, triangulator, compass, sextant, watch, speedometer, quadcorder

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
	if inv:contains_item("main", "orienteering:quadcorder") then
		quadcorder = true
	end

	local str_pos, str_angles, str_time, str_speed
	local pos = vector.apply(player:getpos(), math.floor)
	if (altimeter and triangulator) or gps or quadcorder then
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
	if ((compass or gps) and sextant) or quadcorder then
		str_angles = "Yaw: "..yaw.."°, pitch: "..pitch.."°"
	elseif compass or gps then
		str_angles = "Yaw: "..yaw.."°"
	elseif sextant then
		str_angles = "Pitch: "..pitch.."°"
	else
		str_angles = ""
	end

	local time = minetest.get_timeofday()
	if watch or gps or quadcorder then
		local totalminutes = time * 1440
		local hours = math.floor(totalminutes / 60)
		local minutes = math.floor(math.fmod(totalminutes, 60))
		local twelve = orienteering.playerhuds[name].twelve
		if twelve then
			local ampm
			if hours == 12 and minutes == 0 then
				str_time = "Time: noon"
			elseif hours == 0 and minutes == 0 then
				str_time = "Time: midnight"
			else
				if hours >= 12 then ampm = "p.m." else ampm = "a.m." end
				hours = math.fmod(hours, 12)
				if hours == 0 then hours = 12 end
				str_time = string.format("Time: %i:%02i %s", hours, minutes, ampm)
			end
		else
			str_time = string.format("Time: %02i:%02i", hours, minutes)
		end
	else
		str_time = ""
	end

	local speed = vector.length(player:get_player_velocity())
	if speedometer or quadcorder then
		str_speed = string.format("Velocity: %.2f %s", speed, orienteering.settings.speed_unit)
	else
		str_speed = ""
	end

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
