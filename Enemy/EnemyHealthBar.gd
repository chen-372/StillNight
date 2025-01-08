extends Control

onready var bar = $ColorRect
var bar_init_length = 0

func _ready():
	bar_init_length = bar.rect_size.x

func change_size(enemy_max_health, current_health):
	bar.rect_size.x = current_health * (bar_init_length / enemy_max_health)
