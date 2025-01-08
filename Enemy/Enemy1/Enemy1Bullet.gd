extends KinematicBody2D

var speed = 350
var velocity = Vector2.ZERO
var forward_dir = 0  # 1 is right, 2 is left
var damage_inherited = 0

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
	
	if forward_dir == 1:
		velocity.x = speed
	else:
		velocity.x = -speed

	velocity.y = rand_range(-speed - 50, speed + 50)
	
	$Hitbox.damage = damage_inherited
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Hitbox_area_entered(area):
	speed -= 50
	if speed <= 0:
		queue_free()

	if area.specific_type == "shield":
		queue_free()
