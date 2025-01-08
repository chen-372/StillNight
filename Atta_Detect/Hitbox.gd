extends Area2D

var damage = 1

const HitEffect = preload("res://Effect/HitEffect.tscn")

func create_hit_effect():
	var hitEffect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_Hitbox_area_entered(area):
	if area.is_enemy:
		create_hit_effect()
