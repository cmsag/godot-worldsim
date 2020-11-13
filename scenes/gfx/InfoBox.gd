extends Node2D

var dragging = false


func _input(event):
	if Input.is_action_just_pressed("left_click") && mouse_in_infobox():
		dragging = true
	if Input.is_action_just_released("left_click"):
		dragging = false
	if Input.is_action_pressed("left_click") && event is InputEventMouseMotion && mouse_in_infobox():
		position += event.relative
	if event is InputEventMouseMotion && dragging && not mouse_in_infobox():
		position +=event.relative

func mouse_in_infobox():
	var right = get_global_mouse_position().x <= position.x + $Background.texture.get_size().x
	var left = get_global_mouse_position().x >= position.x
	var bottom = get_global_mouse_position().y >= position.y
	var top = get_global_mouse_position().y <= position.y + $Background.texture.get_size().y
	if right && left && top && bottom:
		return true
