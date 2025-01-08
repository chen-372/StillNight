extends KinematicBody2D

var speed = 500
var velocity = Vector2.ZERO
var ex_damage_bonus = 0
var tmp_damage_val = 0
export var bullet_type = "normal"	#never remove export property

func _ready():
	if bullet_type != "normal":
		get_parent().speed += Playerstats.speed_damage_bonus * 60
	else:
		speed += Playerstats.speed_damage_bonus * 60

	$Hitbox.damage = Playerstats.projectile_damage_multiplier + Playerstats.speed_damage_bonus
	tmp_damage_val = $Hitbox.damage

func _physics_process(_delta):
	if bullet_type != "normal":
		$Hitbox.damage = tmp_damage_val + ex_damage_bonus
	else:
		velocity = move_and_slide(velocity)
	
		if abs(velocity.x) < 100 && abs(velocity.y) < 100:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	if bullet_type != "normal":
		get_parent().queue_free()
	else:
		queue_free()

func _on_Hitbox_area_entered(_area):
	if bullet_type == "sniperShot":
		return

	if bullet_type != "normal":
		get_parent().queue_free()
	else:
		queue_free()
