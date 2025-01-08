extends ParallaxLayer

export(float) var speed = 1
const GainSkill = preload("res://UI/GainSkill.tscn")

func _ready():
	GlobalSys.init_game_stats()

func _physics_process(_delta):
	motion_offset.x -= speed

func _on_initial_skill_timeout():
	var gainSkill = GainSkill.instance()
	get_parent().get_parent().add_child(gainSkill)
	$initial_skill.queue_free()
