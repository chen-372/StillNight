extends StaticBody2D

var is_dead = false
var screen_entered = false
var health = 3
var reward_battery = 13

export var has_back = true
export var is_releaser = false

onready var hurtbox = $Hurtbox

const DestroyedEffect = preload("res://Effect/ScreenDestroyedEffect.tscn")
const WeaponGear = preload("res://Enemy/WeaponGear.tscn")

func _ready():
	if is_releaser:
		health = 0.1
		reward_battery += 25

func die():
	$die.play()
	is_dead = true
	call_deferred("hcd")

	var effect = DestroyedEffect.instance()
	var main = get_tree().current_scene
	main.get_node("Moveable").get_node("Effect_Node").add_child(effect)
	effect.global_position = get_node("AnimatedSprite").global_position

	Playerstats.battery += reward_battery
	GlobalSys.player_points += 10
	get_node("Particles2D").visible = false

	if has_back:
		get_node("ColorRect").visible = true

	if is_releaser:
		for _i in range(round(rand_range(4, 6))):
			call_deferred("mga")
			
func hcd():
	$Hurtbox/CollisionShape2D.disabled = true

func mga():
	var main = get_tree().current_scene
	var weaponGear = WeaponGear.instance()
	main.get_node("Moveable").add_child(weaponGear)
	weaponGear.global_position = get_node("AnimatedSprite").global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
	
func _on_Hurtbox_area_entered(area):
	health -= area.damage
	if health <= 0 && is_dead == false:
		die()
