extends Node

# Object for reading from the data maps

var MAP_AVERAGE_TEMPERATURE
var MAP_SEA
var MAP_HEIGHT
var MAP_RIVER_PROXIMITY
var MAP_NAVIGABLE_RIVERS
var MAP_COASTAL

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get references for all data map files
	MAP_AVERAGE_TEMPERATURE = $MapContainer/TemperatureMap.texture.get_data()
	MAP_AVERAGE_TEMPERATURE.lock()
	
	MAP_SEA = $MapContainer/OceanMap.texture.get_data()
	MAP_SEA.lock()
	
	MAP_HEIGHT = $MapContainer/HeightMap.texture.get_data()
	MAP_HEIGHT.lock()
	
	MAP_RIVER_PROXIMITY = $MapContainer/RiverProximityMap.texture.get_data()
	MAP_RIVER_PROXIMITY.lock()
	
	MAP_NAVIGABLE_RIVERS = $MapContainer/NavigableRiverMap.texture.get_data()
	MAP_NAVIGABLE_RIVERS.lock()
	
	MAP_COASTAL = $MapContainer/CoastalMap.texture.get_data()
	MAP_COASTAL.lock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_mappix(map, coordinates):
	# Always get Red value (arbitrary choice).
	# Maps are all greyscale, so ideally just luminosity could be used
	# but I don't know of a method of getting that data
	return map.get_pixelv(coordinates)[0]

func get_average_temperature(coordinates):
	# Average temperature. Raw values in F, translate to C because more civilised
	var average_temperature = get_mappix(MAP_AVERAGE_TEMPERATURE, coordinates)
	average_temperature = average_temperature * 100
	# F to C
	average_temperature = stepify(((average_temperature - 32) * 5) / 9, 0.1)
	# END Average temperature
	#
	return average_temperature

func get_is_sea(coordinates):
	# Check if this part of the map is sea or not.
	var picked_pixel = get_mappix(MAP_SEA, coordinates)
	if picked_pixel > 0:
		return true
	else:
		return false

func get_altitude(coordinates):
	var altitude = get_mappix(MAP_HEIGHT, coordinates)
	# Get exponent of the map's raw altitude data
	altitude = pow(altitude * 10, 6)
	return altitude

func get_is_near_river(coordinates):
	# Check whether the pixel is near a river - it need not be navigable.
	var minor_river = get_mappix(MAP_RIVER_PROXIMITY, coordinates)
	var navigable_river = get_mappix(MAP_NAVIGABLE_RIVERS, coordinates)
	# Check if near either a minor river or navigable river
	if minor_river > 0 or navigable_river > 0:
		return true
	else:
		return false

func get_is_by_navigable_river(coordinates):
	var picked_pixel = get_mappix(MAP_NAVIGABLE_RIVERS, coordinates)
	if picked_pixel > 0:
		return true
	else:
		return false

func get_is_coastal(coordinates):
	var picked_pixel = get_mappix(MAP_COASTAL, coordinates)
	if picked_pixel > 0:
		return true
	else:
		return false
