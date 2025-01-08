extends KinematicBody2D

const Normal_Bullet = preload("res://Player/PlayerBullet.tscn")
var velocity = Vector2.ZERO
var speed = 500

func _ready():
	$PlayerBullet.ex_damage_bonus = 2
	Playerstats.battery -= 7

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _on_Hitbox_area_entered(_area):
	var tmp = [Vector2.UP + Vector2.RIGHT, Vector2.UP + Vector2.LEFT, Vector2.DOWN + Vector2.RIGHT, Vector2.DOWN + Vector2.LEFT]

	for i in tmp:
		call_deferred("explode", i)
		call_deferred("explode", Vector2(rand_range(-1, 1), rand_range(-1, 1)))

func explode(pos):
	var bullet = Normal_Bullet.instance()
	get_parent().add_child(bullet)
	bullet.modulate = Color("dfe025")
	bullet.ex_damage_bonus = rand_range(-0.9, 3)
	bullet.global_position = position
	bullet.velocity = pos * speed
