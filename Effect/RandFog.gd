extends Node2D

var tmp = 0.05

func _process(_delta):
	if GlobalSys.pause_all_spawn:
		modulate.r += rand_range(-tmp, tmp)
		modulate.g += rand_range(-tmp, tmp)
		modulate.b += rand_range(-tmp, tmp)
