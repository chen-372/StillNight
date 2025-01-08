extends AnimatedSprite

func _ready():
	frame = 0
	play("effect")

func _on_HitEffect_animation_finished():
	queue_free()

func _on_EnemyDestroyedEffect_animation_finished():
	queue_free()

func _on_ScreenDestroyedEffect_animation_finished():
	queue_free()

func _on_fireExplodeEffect_animation_finished():
	queue_free()
