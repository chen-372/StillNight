extends KinematicBody2D

var rage_state = false
var velocity = Vector2.ZERO
var max_health = 0
var player_entered_shield = false
var distance_to_player = 0

onready var stats = $Enemystats

const Lazer = preload("res://Enemy/Boss1/Boss1Lazer.tscn")

func _ready():
	stats.health = 20
	$AnimatedSprite.frame = 0
	$rage_effect.modulate.a = 0
	max_health = stats.health
	modulate.a = 0
	GlobalSys.boss_exist = true

func _physics_process(delta):
	if modulate.a < 1:
		modulate.a += delta

	velocity = move_and_slide(velocity)
	effecting(delta)
	$EnemyHealthBar.change_size(max_health, stats.health)
	
	if rage_state:
		velocity = Vector2.ZERO

		if player_entered_shield:
			if stats.health < max_health:
				if has_node("Boss1Lazer"):
					stats.health += delta * 2
				else:
					stats.health += delta * 5
			Playerstats.system_cracked = true

	else:
		distance_to_player = sqrt((Playerstats.player_position.x - global_position.x) * (Playerstats.player_position.x - global_position.x) + (Playerstats.player_position.y - global_position.y) * (Playerstats.player_position.y - global_position.y))
		if $rage_state.time_left < 1:
			stats.speed = 600 + (max_health - stats.health) * 10
			velocity = velocity.move_toward(global_position.direction_to(Playerstats.player_position) * stats.speed, stats.speed * delta)
		else:
			stats.speed = 400 + (max_health - stats.health) * 10
			if distance_to_player > 300:
				velocity = velocity.move_toward(global_position.direction_to(Playerstats.player_position) * stats.speed, stats.speed * delta)
			else:
				velocity = velocity.move_toward(global_position.direction_to(Playerstats.player_position) * -stats.speed, stats.speed * delta)

func change_state():
	if $AnimatedSprite.frame == 0:
		if GlobalSys.battle_phase > 3 && stats.health < max_health * 0.5:
			var tmp = 184
			global_position = Vector2(608, 288) + Vector2(rand_range(-tmp, tmp), rand_range(-tmp, tmp))
		$AnimatedSprite.play()
		rage_state = true
		
		for _i in range(round(rand_range(3, 5))):
			call_deferred("spawn_lazer")

	elif $AnimatedSprite.frame == $AnimatedSprite.frames.get_frame_count("all") - 1:
		$AnimatedSprite.play("all", true)
		rage_state = false
		
	$rage_state.start(rand_range(4, 6))

func spawn_lazer():
	var lazer = Lazer.instance()
	lazer.rotate_speed = 25 + (max_health - stats.health) * 2
	lazer.damage = GlobalSys.battle_phase * 2 + stats.damage
	add_child(lazer)

func effecting(delta):
	var rotate_speed = 4 + GlobalSys.battle_phase
	
	if rage_state:
		if $rage_effect.modulate.a < 1:
			$rage_effect.modulate.a += delta
			
		$rage_effect.rotation_degrees += rotate_speed

	else:
		if $rage_effect.modulate.a > 0:
			$rage_effect.modulate.a -= delta

func _on_Hurtbox_area_entered(area):
	if rage_state:
		stats.health -= area.damage * clamp(0.5 + (stats.health / max_health), 0, 1)
	else:
		stats.health -= area.damage * 0.05

	if stats.health <= 0 && stats.is_dead == false:
		player_entered_shield = false
		stats.die(true)

func _on_rage_state_timeout():
	change_state()
	
func _on_ObjectDetectionZone_body_entered(_body):
	player_entered_shield = true
	
	if rage_state:
		Playerstats.velocity = Vector2.ZERO

func _on_ObjectDetectionZone_body_exited(_body):
	player_entered_shield = false
