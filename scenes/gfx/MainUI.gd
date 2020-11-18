extends Node

var avg_temp
var mouse_position

var SATELLITE_MAP_SIZE # May be any size
export var DATA_MAP_SIZE = Vector2(1000, 500)

var MAP_SATELLITE

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Once maps are instantiated, store them as variables for ease of access
	MAP_SATELLITE = $MapCanvas/ViewportContainer/Viewport/MapContainer/SatelliteMap
	SATELLITE_MAP_SIZE = MAP_SATELLITE.texture.get_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update mouse position
	mouse_position = $MapCanvas/ViewportContainer/Viewport/MapContainer/SatelliteMap.get_global_mouse_position()
	update_infobox_data()

func get_mouse_position_data():
	# Get data from data maps based on the mouse's position on canvas
	# This populates the value fields in the InfoBox object
	var coordinates = get_translated_coordinates()
	var data_values = {
		"average_temperature": $MapDataReader.get_average_temperature(coordinates),
		"is_sea": $MapDataReader.get_is_sea(coordinates),
		"altitude": $MapDataReader.get_altitude(coordinates),
		"is_coastal": $MapDataReader.get_is_coastal(coordinates),
		"is_near_river": $MapDataReader.get_is_near_river(coordinates),
		"is_navigable_river": $MapDataReader.get_is_by_navigable_river(coordinates)
		}
	return data_values

func get_translated_coordinates():
	# Get the mouse position relative to the corner of the map texture
	# Translate coordinates of larger satellite map to respective position on data maps
	var translated_coordinates = mouse_position * (DATA_MAP_SIZE / SATELLITE_MAP_SIZE)
	return translated_coordinates

func update_infobox_data():
	$InfoBox/TemperatureValue.text = str(get_mouse_position_data()["average_temperature"]) + "°C"
	$InfoBox/IsSeaValue.text = str(get_mouse_position_data()["is_sea"])
	$InfoBox/AltitudeValue.text = str(get_mouse_position_data()["altitude"]) + " m"
	$InfoBox/IsCoastalValue.text = str(get_mouse_position_data()["is_coastal"])
	$InfoBox/IsNearRiverValue.text = str(get_mouse_position_data()["is_near_river"])
	$InfoBox/NavigableRiverValue.text = str(get_mouse_position_data()["is_navigable_river"])
