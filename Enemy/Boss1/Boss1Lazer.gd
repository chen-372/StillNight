extends KinematicBody2D

var rotate_speed = 20
var self_destroy = false
var damage = 0

func _ready():
	rotation_degrees = 0
	$Hitbox.damage = damage
	modulate.a = 0
	rotation_degrees = rand_range(0, 360)

func _physics_process(delta):
	if self_destroy:
		modulate.a -= delta * 0.5
		if modulate.a <= 0:
			queue_free()
	else:
		if modulate.a <= 1:
			modulate.a += delta * 0.1
		
		if rotation_degrees >= 360:
			rotation_degrees = 0
		rotation_degrees += rotate_speed * delta
	
func _on_self_destroy_timeout():
	self_destroy = true

func _on_Hitbox_area_entered(area):
	get_parent().get_node("Enemystats").fireExplodeEffecting(area.global_position)
