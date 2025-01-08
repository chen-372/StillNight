extends Area2D

var object = null

func _on_ObjectDetectionZone_body_entered(body):
	object = body

func _on_ObjectDetectionZone_body_exited(_body):
	object = null

func object_detect():
	if object != null:
		return object
