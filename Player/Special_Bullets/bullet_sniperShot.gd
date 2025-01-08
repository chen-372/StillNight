extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 1500

func _ready():
	$PlayerBullet.ex_damage_bonus = Playerstats.sniper_damage + 10
	
	if Playerstats.battery - Playerstats.sniper_damage < 10:
		Playerstats.battery += 10

	Playerstats.battery -= Playerstats.sniper_damage
	
	Playerstats.sniper_damage = 0

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
