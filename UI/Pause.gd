extends CanvasLayer

func _ready():
	set_visible(false)
	
func _process(_delta):
	if get_tree().current_scene.name == "Game":
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if event.is_action_pressed("ui_cancel") && GlobalSys.choosing_upgrades == false:
		if get_tree().current_scene.name != "End_UI" && get_tree().current_scene.name != "Start_Menu" && get_tree().current_scene.name != "SelectModule":
			set_visible(!get_tree().paused)
			get_tree().paused = !get_tree().paused
	
func _on_Continue_pressed():
	get_tree().paused = false
	set_visible(false)
	
func set_visible(is_visible):
	for node in get_children():
		node.visible = is_visible

func _on_Fullscreen_pressed():
	OS.window_fullscreen = !OS.window_fullscreen

func _on_Restart_pressed():
	set_visible(false)
	get_tree().paused = false
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Quit_pressed():
# warning-ignore:return_value_discarded
	get_tree().paused = false
	set_visible(false)
	get_tree().change_scene("res://UI/Start_Menu.tscn")
