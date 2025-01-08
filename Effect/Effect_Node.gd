extends YSort

func _physics_process(_delta):
	if get_child_count() != 0:
		for i in get_child_count():
			get_child(i).global_position.x -= GlobalSys.building_forward_speed
