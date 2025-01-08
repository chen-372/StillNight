extends KinematicBody2D

onready var stats = $Enemystats

var max_health = 0

const WeaponGear = preload("res://Enemy/WeaponGear.tscn")

func _ready():
	max_health = stats.health

func _physics_process(_delta):
	global_position.x -= GlobalSys.building_forward_speed
	$EnemyHealthBar.change_size(max_health, stats.health)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
		
	if stats.health <= 0 && stats.is_dead == false:
		stats.die()

func _on_VisibilityNotifier2D_screen_entered():
	stats.screen_entered = true
	$Spawn.start()

func _on_VisibilityNotifier2D_screen_exited():
	if stats.screen_entered:
		queue_free()

func _on_Spawn_timeout():
	var weaponGear = WeaponGear.instance()
	get_parent().add_child(weaponGear)
	weaponGear.global_position = $SpawnPos.global_position
