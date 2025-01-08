extends KinematicBody2D

var friction = 1000
var in_click = false

var bullet_cost_battery = 0.9

var evade_detect = null
var evaded = false

var Shield = null
var bullet = preload("res://Player/PlayerBullet.tscn")

func _ready():
	for i in range(0, $aim_dir.get_child_count()):
		$aim_dir.get_child(i).visible = false

	evade_detect = $evade/ObjectDetectionZone
	Shield = preload("res://Player/Shield.tscn")

func _physics_process(delta):
	Playerstats.battery_loss_speed = Playerstats.const_battery_loss_speed + Playerstats.acceleration / 1200
	
	Playerstats.velocity = move_and_slide(Playerstats.velocity)
	battery_control()
	
	shooting()
	motion(delta)
		
	Playerstats.battery -= Playerstats.battery_loss_speed * delta
	Playerstats.player_position = global_position

	for i in range($aim_dir.get_child_count()):
		$aim_dir.get_child(i).visible = Playerstats.aim_dir[$aim_dir.get_child(i).name]

	if Playerstats.evade:
		if $evade.modulate.a < 0.13:
			$evade.modulate.a += delta
		run_evade()
	else:
		if $evade.modulate.a > 0:
			$evade.modulate.a -= delta
	
	if Playerstats.marginal_defense:
		run_marginal_defense()

	run_bullet_specialist()
	destructive_mode_control()
	
	if Playerstats.system_cracked:
		Playerstats.max_battery -= 3 * delta
		
func destructive_mode_control():
	if Playerstats.current_bullet_type == "destructive":
		if Playerstats.sniper_damage < Playerstats.battery && Playerstats.sniper_damage < 370:
			Playerstats.sniper_damage += 0.8
		elif Playerstats.sniper_damage > Playerstats.battery:
			Playerstats.sniper_damage = Playerstats.battery

		modulate.a = 0.6
		if has_node("sniperRay") == false:
			var ray = preload("res://Player/Special_Bullets/sniperRay.tscn").instance()
			ray.position = $AnimatedSprite.position
			add_child(ray)
		if Input.is_action_pressed("move_up") :
			$sniperRay.rotation_degrees -= 0.1
		if Input.is_action_pressed("move_down"):
			$sniperRay.rotation_degrees += 0.1
	else:
		if has_node("sniperRay"):
			$sniperRay.queue_free()
		modulate.a = 1
		Playerstats.sniper_damage = 0

func shooting():
	if Input.is_mouse_button_pressed(1):
		if in_click == false:
			in_click = true
			$Sound/shoot.play()
			if Playerstats.current_bullet_type == "destructive":
				spawn_bullet($sniperRay/Position2D.global_position)
			else:
				spawn_bullet(get_global_mouse_position())

	else:
		in_click = false
		if Input.is_action_just_pressed("shoot"):
			$Sound/shoot.play()
			if Playerstats.current_bullet_type == "destructive":
				spawn_bullet($sniperRay/Position2D.global_position)
			else:
				spawn_bullet(get_global_mouse_position())

func motion(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		Playerstats.velocity = Playerstats.velocity.move_toward(input_vector * Playerstats.max_speed, Playerstats.acceleration * delta)
	else:
		Playerstats.velocity = Playerstats.velocity.move_toward(Vector2.ZERO, friction * delta)

func battery_control():
	if Playerstats.battery <= 0:
		queue_free()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://UI/End_UI.tscn")

	Playerstats.battery = clamp(Playerstats.battery, -1, Playerstats.max_battery)

func run_evade():
	$evade.rotation_degrees += 0.5
	$evade.scale = Playerstats.detect_range
	
	var enemy_bullet = evade_detect.object
	if enemy_bullet != null && evaded == false:
		$Hurtbox/CollisionShape2D.disabled = true
		
		var tmp = 100
		global_position = get_global_mouse_position() + Vector2(rand_range(-tmp, tmp), rand_range(-tmp, tmp))
		
		$evade/evade.start()
		$evade.modulate.a += 0.5
		evaded = true
	
func run_marginal_defense():
	if Playerstats.battery >= Playerstats.max_battery - 1 && Playerstats.has_shield == false:
		var shield = Shield.instance()
		add_child(shield)
		Playerstats.has_shield = true

func run_bullet_specialist():
	if Playerstats.current_bullet_type == "normal":
		bullet = preload("res://Player/PlayerBullet.tscn")
	
	elif Playerstats.current_bullet_type == "explosive":
		bullet = preload("res://Player/Special_Bullets/bullet_explosive.tscn")
	
	elif Playerstats.current_bullet_type == "lingering":
		bullet = preload("res://Player/Special_Bullets/bullet_EMPBomb.tscn")
	
	elif Playerstats.current_bullet_type == "linker":
		bullet = preload("res://Player/Special_Bullets/bullet_linker.tscn")
	
	elif Playerstats.current_bullet_type == "destructive":
		bullet = preload("res://Player/Special_Bullets/bullet_sniperShot.tscn")
	
func spawn_bullet(target_dir):
	Playerstats.velocity = Vector2(Playerstats.velocity.x * 0.25, Playerstats.velocity.y * 0.25)
	
	if Playerstats.current_bullet_type != "destructive":
		for i in range(0, $aim_dir.get_child_count()):
			if $aim_dir.get_child(i).visible:
				var bullet_lc = bullet.instance()
				get_parent().add_child(bullet_lc)
				bullet_lc.global_position = position
				Playerstats.battery -= bullet_cost_battery * Playerstats.projectile_damage_multiplier
				bullet_lc.velocity = bullet_lc.global_position.direction_to($aim_dir.get_child(i).global_position) * bullet_lc.speed

	var bullet_lc = bullet.instance()
	get_parent().add_child(bullet_lc)
	bullet_lc.global_position = position
	Playerstats.battery -= bullet_cost_battery * Playerstats.projectile_damage_multiplier
	bullet_lc.velocity = bullet_lc.global_position.direction_to(target_dir) * bullet_lc.speed

func _on_Hurtbox_area_entered(area):
	$Sound/player_get_hurt.play()
	Playerstats.battery -= area.damage
	Playerstats.get_hurt = true
	$Hurtbox/Timer.start()

func _on_evade_timeout():
	Playerstats.battery -= 2
	$evade.modulate.a -= 0.5
	evaded = false
	$Hurtbox/CollisionShape2D.disabled = false

func _on_bullet_use_duration_timeout():
	Playerstats.current_bullet_type = ""

func _on_Timer_timeout():
	Playerstats.get_hurt = false
