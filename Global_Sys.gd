extends Node

var building_forward_speed = 0
var max_building_forward_speed = 0
var player_points = 0
var game_time = 0
var pause_all_spawn = false
var pause_interval = 70
var pause_time = 25
var battle_phase = 1
var time_stopped = false

var module_names = ["Velocity Control", "Attack Methodology", "Defenstive Detection", "Bullet Specialist"]#, "Seperation Strategy (in developing)"]

var boss_exist = false
var ui_error_sign_visibility = 0

var choosing_upgrades = false

func _ready():
	randomize()

func init_game_stats():
	Playerstats.velocity = Vector2.ZERO
	Playerstats.max_battery = 400.0
	Playerstats.battery = Playerstats.max_battery * 0.5
	Playerstats.battery_loss_speed = 1.1
	Playerstats.const_battery_loss_speed = 1
	Playerstats.default_acceleration = 950
	Playerstats.default_max_speed = 1000
	Playerstats.speed_damage_bonus = 0
	Playerstats.player_position = Vector2.ZERO
	Playerstats.system_cracked = false
	Playerstats.projectile_damage_multiplier = 1
	Playerstats.get_hurt = false
	Playerstats.sniper_damage = 0
	Playerstats.upgrades = ["None", ""]
	Playerstats.remove_upgrades()
	
	time_stopped = false
	player_points = 0
	game_time = 0
	building_forward_speed = 3.0
	max_building_forward_speed = 8
	pause_all_spawn = false
	boss_exist = false
	ui_error_sign_visibility = 0
	battle_phase = 1
	choosing_upgrades = false
	
func _on_speed_update_timeout():
	if building_forward_speed < max_building_forward_speed:
		building_forward_speed += 0.2

func _on_game_time_counter_timeout():
	if get_tree().current_scene.name == "Game":
		game_time += 1
		
		if game_time % pause_interval == 0:
			pause_all_spawn = true
			$pause_time.start(pause_time)

func _on_pause_time_timeout():
	if pause_all_spawn == true:
		pause_all_spawn = false
		battle_phase += 1
