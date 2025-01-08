extends KinematicBody2D

onready var stats = $Enemystats

var velocity = Vector2(rand_range(-100, 100), rand_range(-100, 100))
var start_shooting = false
var max_health = 0

const Bullet = preload("res://Enemy/Enemy1/Enemy1Bullet.tscn")

func _ready():
	$CollisionShape2D.disabled = true
	$Hurtbox/CollisionShape2D.disabled = true
	max_health = stats.health

func _physics_process(_delta):
	rand_motion()
	
	$EnemyHealthBar.change_size(max_health, stats.health)

func rand_motion():
	velocity = move_and_slide(velocity)
	$AnimatedSprite.flip_h = !global_position.direction_to(Playerstats.player_position).x < 0
	
	if stats.screen_entered:
		if abs(velocity.x) < 10 || abs(velocity.y) < 10:
			_on_wander_update_timeout()
	else:
		velocity.x = -250

func _on_Hurtbox_area_entered(area):
	_on_wander_update_timeout()
	stats.health -= area.damage

	if stats.health <= 0 && stats.is_dead == false:
		stats.die()

func spawn_bullet():
	var bullet = Bullet.instance()
	bullet.damage_inherited = stats.damage
	
	if $AnimatedSprite.flip_h:
		bullet.forward_dir = 1
	else:
		bullet.forward_dir = 2
	
	get_parent().add_child(bullet)
	
	if $AnimatedSprite.flip_h == false:
		bullet.global_position = $shoot_pos.global_position
	else:
		bullet.global_position = $shoot_pos2.global_position

func _on_wander_update_timeout():
	if rand_range(0, 5) < 2:
		$shooting_time.start()
		$shoot_interval.start()
		
	velocity.x = rand_range(-stats.speed, stats.speed)
	velocity.y = rand_range(-stats.speed, stats.speed)

func _on_enable_collision_timeout():
	$CollisionShape2D.disabled = false
	$Hurtbox/CollisionShape2D.disabled = false

func _on_shooting_time_timeout():
	$shoot_interval.stop()

func _on_VisibilityNotifier2D_screen_entered():
	stats.screen_entered = true
	$enable_collision.start()
	$wander_update.start()

func _on_VisibilityNotifier2D_screen_exited():
	if stats.screen_entered:
		queue_free()

func _on_shoot_interval_timeout():
	if stats.screen_entered:
		spawn_bullet()
