extends Node2D

var velocity = Vector2.ZERO
var battery = 0.0			#change in global_sys init function
var max_battery = 0.0		#change in global_sys init function
var battery_loss_speed = 0		#change in _process function below
var const_battery_loss_speed = 1	#change in global_sys init function
var player_position = Vector2.ZERO
var system_cracked = false
var speed_damage_bonus = 0		#update in the UIs .gd file
var get_hurt = false

const error_found_cost_battery = 30
const uploading_code_battery_cost = 5

#physical properties, refreshed to default in global_sys init function
var acceleration = 0
var default_acceleration = 0
var max_speed = 0
var default_max_speed = 0
var projectile_damage_multiplier = 0
var aim_dir = {
	"right" : false,
	"left" : false,
	"down" : false,
	"up" : false,
	"up_left" : false,
	"up_right" : false,
	"down_left" : false,
	"down_right" : false
}

var evade = false
var marginal_defense = false
var has_shield = false
var detect_range = Vector2(0, 0)

var sniper_damage = 0

var current_bullet_type = ""

var upgrades = ["", ""]

func remove_upgrades():
	var tmp = ["right", "left", "down", "up", "up_left", "up_right", "down_left", "down_right"]
	for i in tmp:
		aim_dir[i] = false
	acceleration = default_acceleration
	max_speed = default_max_speed
	marginal_defense = false
	evade = false
	detect_range = Vector2(0, 0)
	current_bullet_type = "normal"
