extends KinematicBody2D

var velocity = Vector2.ZERO
var acceleration = 900
var max_speed = 1000

func _ready():
	$Hitbox.damage = $Enemystats.damage

func _physics_process(delta):
	velocity = move_and_slide(velocity)

	$AnimatedSprite.rotation_degrees += 400 * delta
	if $AnimatedSprite.rotation_degrees >= 360:
		$AnimatedSprite.rotation_degrees = 0

	velocity = velocity.move_toward(global_position.direction_to(Playerstats.player_position) * max_speed, acceleration * $Enemystats.speed * delta)

func _on_self_destroy_timeout():
	gearDie()

func _on_Hitbox_area_entered(_area):
	gearDie()

func _on_Hurtbox_area_entered(area):
	if area.damage > 4:
		gearDie()
		Playerstats.battery += 8
		GlobalSys.player_points += 5
	else:
		velocity = Vector2.ZERO

func gearDie():
	$Enemystats.fireExplodeEffecting()
	queue_free()
	$Enemystats/enemyDie.play()
