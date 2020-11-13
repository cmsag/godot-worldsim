extends Viewport

var ViewportInfo : Rect2 = get_visible_rect()
var map_cornerpos 

# Called when the node enters the scene tree for the first time.
func _ready():
	# Define variables used by parent nodes here
	pass

func get_map_cornerpos():
	# Get size of texture minus window size
	var map_screen_size = $MapContainer/SatelliteMap.texture.get_size()
	if OS.get_window_size() < map_screen_size:
		map_cornerpos = map_screen_size - OS.get_window_size()
		# Ensure that the corner position is relative to zoom, to avoid being lcoked in while zoomed
		map_cornerpos = map_screen_size - ( OS.get_window_size() * $Camera.zoom )
	return map_cornerpos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Ensure that the camera does not go off-screen
	$Camera.global_position.x = clamp($Camera.global_position.x, 0, abs(get_map_cornerpos().x))
	$Camera.global_position.y = clamp($Camera.global_position.y, 0, abs(get_map_cornerpos().y))
