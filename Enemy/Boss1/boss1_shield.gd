extends Node2D

export var is_decorative = false

func _on_ObjectDetectionZone_body_entered(body):
	var tmp = 200
	body.velocity = body.global_position.direction_to(global_position + Vector2(rand_range(-tmp, tmp), rand_range(-tmp, tmp))) * 600

func _process(_delta):
	if !is_decorative:
		$ObjectDetectionZone/CollisionShape2D.disabled = !get_parent().get_parent().rage_state
		$Particles2D.process_material.scale = 0.15
	else:
		$Particles2D.local_coords = true
		$Particles2D.process_material.scale = 0.06
		$ObjectDetectionZone/CollisionShape2D.disabled = true
