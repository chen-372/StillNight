extends Node2D

export(float) var health = 1
export(float) var damage = 1
export(float) var speed = 1
var is_dead = false
var screen_entered = false
var linked = false

const DestroyedEffect = preload("res://Effect/EnemyDestroyedEffect.tscn")
const fireExplodeEffect = preload("res://Effect/fireExplodeEffect.tscn")
const GainSkill = preload("res://UI/GainSkill.tscn")

func _ready():
	health += GlobalSys.battle_phase * 1.5
	damage += GlobalSys.battle_phase * 2

func _process(delta):
	if linked:
		if get_parent().has_node("transfer_link") == false:
			get_parent().add_child(preload("res://Player/transfer_link.tscn").instance())
		else:
			if health < 2:
				get_parent().get_node("transfer_link").queue_free()
				linked = false

		health -= delta * 0.5
		Playerstats.battery += delta * health

		get_parent().get_node("transfer_link/Position1").global_position = get_parent().global_position
		get_parent().get_node("transfer_link/Position2").global_position = Playerstats.player_position

func die(is_boss=false):
	if is_boss:
		Playerstats.system_cracked = false
		GlobalSys.boss_exist = false
		var gainSkill = GainSkill.instance()
		get_parent().get_parent().add_child(gainSkill)
		
		Playerstats.battery = Playerstats.max_battery
		GlobalSys.player_points += 100
		GlobalSys.pause_all_spawn = false
		GlobalSys.battle_phase += 1

	is_dead = true
	GlobalSys.player_points += 29
	get_parent().queue_free()
	enemyDestroyedEffecting()
	Playerstats.battery += GlobalSys.battle_phase * 4
	$enemyDie.play()
	
func enemyDestroyedEffecting():
	var main = get_tree().current_scene
	var effect = DestroyedEffect.instance()
	main.add_child(effect)
	effect.global_position = get_parent().get_node("Hurtbox").global_position

func fireExplodeEffecting(pos = Vector2.ZERO):
	var main = get_tree().current_scene
	var effect = fireExplodeEffect.instance()
	main.add_child(effect)
	if pos == Vector2.ZERO:
		effect.global_position = get_parent().get_node("AnimatedSprite").global_position
	else:
		effect.global_position = pos
