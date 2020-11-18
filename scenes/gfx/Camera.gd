extends Camera2D

export var NAVIGATE_SPEED = 0.1

export var ZOOM_STEP = Vector2(0.1, 0.1)
export var MAX_ZOOM = Vector2(0.1, 0.1)
export var MIN_ZOOM = Vector2(2.0, 2.0)
 
# Toggle point for mouse-based map navigation
var fixed_toggle_point = Vector2(0,0)
var viewport_size = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Map navigation
	if Input.is_action_just_pressed("navigate_map"):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	if Input.is_action_pressed("navigate_map"):
		navigate_map()

	# Map zoom
	if Input.is_action_just_released("zoom_out"):
		zoom_out()
	if Input.is_action_just_released("zoom_in"):
		zoom_in()

func get_cursor_zoom_pos():
	pass

### Camera navigation functions ###

func zoom_out():
	if zoom <= MIN_ZOOM:
		zoom += ZOOM_STEP

func zoom_in():
	if zoom >= MAX_ZOOM:
		zoom -= ZOOM_STEP

func navigate_map():
	var ref = get_viewport().get_mouse_position()
	global_position.x += ((fixed_toggle_point.x - ref.x) * zoom.x ) * NAVIGATE_SPEED
	fixed_toggle_point.x -= ((fixed_toggle_point.x - ref.x) * zoom.x ) * NAVIGATE_SPEED
	global_position.y += ((fixed_toggle_point.y - ref.y) * zoom.y ) * NAVIGATE_SPEED
	fixed_toggle_point.y -= ((fixed_toggle_point.y - ref.y) * zoom.y ) * NAVIGATE_SPEED
