extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = 500

func _ready():
	Playerstats.battery -= 1
	$PlayerBullet.ex_damage_bonus = -0.5

func _physics_process(_delta):
	velocity = move_and_slide(velocity)

func _on_Hitbox_area_entered(area):
	if area.get_parent().has_node("Enemystats") && area.get_parent().get_node("Enemystats").health > 1:
		area.get_parent().get_node("Enemystats").linked = true
