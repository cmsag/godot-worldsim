extends Node

var avg_temp
var mouse_position

var SATELLITE_MAP_SIZE
var DATA_MAP_SIZE

var MAP_SATELLITE
var MAP_AVERAGE_TEMPERATURE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Once maps are instantiated, store them as variables for ease of access
	MAP_SATELLITE = $MapCanvas/ViewportContainer/Viewport/MapContainer/SatelliteMap
	SATELLITE_MAP_SIZE = MAP_SATELLITE.texture.get_size()
	# Any data map could be used to get data map size as they should all be the same size 
	DATA_MAP_SIZE = $MapCanvas/ViewportContainer/Viewport/MapContainer/TemperatureMap.texture.get_size()
	# Get references for all data map files
	MAP_AVERAGE_TEMPERATURE = $MapCanvas/ViewportContainer/Viewport/MapContainer/TemperatureMap.texture.get_data()
	MAP_AVERAGE_TEMPERATURE.lock()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update mouse position
	mouse_position = $MapCanvas/ViewportContainer/Viewport/MapContainer/SatelliteMap.get_global_mouse_position()
	update_infobox_data()

func get_mouse_position_data(coordinates):
	# Get data from data maps based on the mouse's position on canvas
	#
	# BEGIN Average temperature. Raw values in F, translate to C because more civilised
	var average_temperature = MAP_AVERAGE_TEMPERATURE.get_pixel(coordinates.x, coordinates.y)
	# Multiply R (or any pixel colour channel) by 100, as value is stored as a grayscale float in RGB
	average_temperature = average_temperature[0] * 100
	# F to C
	average_temperature = stepify(((average_temperature - 32) * 5) / 9, 0.1)
	# END Average temperature
	#
	# BEGIN Is sea Y/N
	# ...WiP...
	return str(average_temperature)

func get_translated_coordinates():
	# Get the mouse position relative to the corner of the map texture
	# Translate coordinates of larger satellite map to respective position on data maps
	var translated_coordinates = mouse_position * (DATA_MAP_SIZE / SATELLITE_MAP_SIZE)
	return translated_coordinates

func update_infobox_data():
	$InfoBox/TemperatureValue.text = get_mouse_position_data(get_translated_coordinates()) + "°C"
