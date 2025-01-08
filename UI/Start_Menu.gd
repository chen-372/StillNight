extends Node2D

var start_pressed = false

func _input(event):
	if event.is_action_pressed("ui_enter"):
# warning-ignore:return_value_discarded
		start_pressed = true
	if event.is_action_pressed("ui_quit"):
		get_tree().quit()

func _process(delta):
	if start_pressed:
		get_node("ParallaxBackground/ParallaxLayer/Sprite").modulate.a -= delta
		get_node("ParallaxBackground/Control").modulate.a -= delta
		if get_node("ParallaxBackground/ParallaxLayer/Sprite").modulate.a <= 0:
# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Game.tscn")
