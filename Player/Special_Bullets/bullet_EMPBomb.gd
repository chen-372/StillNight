extends KinematicBody2D

const EMP_area = preload("res://Player/Special_Bullets/EMP_Area.tscn")

var velocity = Vector2.ZERO
var speed = 500

func _ready():
	Playerstats.battery -= 3
	$PlayerBullet.ex_damage_bonus = 0.5

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _on_Hitbox_area_entered(_area):
	call_deferred("gac")

func gac():
	var tmp = EMP_area.instance()
	tmp.global_position = position
	get_parent().add_child(tmp)
