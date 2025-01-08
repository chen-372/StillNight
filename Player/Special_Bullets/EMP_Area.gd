extends AnimatedSprite

func _on_ObjectDetectionZone_body_entered(body):
	body.get_node("Enemystats").speed *= 0.4
	body.get_node("Enemystats").damage *= 0.5
	body.get_node("Enemystats").health *= 0.8
	body.get_node("Enemystats").health -= 0.1

	if body.modulate.r > 0.3:
		body.modulate.r *= 2
		body.modulate.g *= 2
		body.modulate.b *= 2
	
func _physics_process(_delta):
	global_position.x -= GlobalSys.building_forward_speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
