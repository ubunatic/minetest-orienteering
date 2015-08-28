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


