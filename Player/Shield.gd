extends Node2D

var density = 300

func _ready():
	modulate.a = 0

func _process(delta):
	if density <= 0:
		modulate.a -= delta
		if modulate.a <= 0:
			Playerstats.has_shield = false
			queue_free()
	else:
		if modulate.a < 1:
			modulate.a += delta
			Playerstats.battery -= 3

	rotation_degrees += 10
	
func _on_Hurtbox_area_entered(area):
	density -= area.damage
