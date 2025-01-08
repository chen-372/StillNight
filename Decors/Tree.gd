extends KinematicBody2D

var is_flipped = false

func _physics_process(_delta):
	global_position.x -= GlobalSys.building_forward_speed
	$AnimatedSprite.flip_h = is_flipped
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
