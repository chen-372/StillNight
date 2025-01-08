extends Control

onready var health_bar = $TextureRect
onready var max_health_bar = $ColorRect

func _ready():
	health_bar.rect_size.x = Playerstats.battery * 7.83
	max_health_bar.rect_size.x = Playerstats.max_battery * 2.37

func _process(_delta):
	health_bar.rect_size.x = Playerstats.battery * 7.83
	max_health_bar.rect_size.x = Playerstats.max_battery * 2.37

	if Playerstats.system_cracked:
		health_bar.modulate = Color("000000")
		max_health_bar.color = Color("ff0000")
	else:
		max_health_bar.color = Color("c2000000")

		if Playerstats.get_hurt:
			health_bar.modulate = Color("ff0060")
		else:
			health_bar.modulate = Color("00fff3")
