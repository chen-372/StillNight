extends Node2D

func _ready():
	$labels/Label3.text += "Total Points: " + str(GlobalSys.player_points) + "\n"
	$labels/Label3.text += "Game Time: " + str(GlobalSys.game_time) + "s"

func _input(event):
	if event.is_action_pressed("ui_quit"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://UI/Start_Menu.tscn")
