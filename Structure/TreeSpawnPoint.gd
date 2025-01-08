extends Position2D

var trees = []
var tree_num = 0
	
func _ready():
	trees.append(preload("res://Decors/Tree1.tscn"))
	trees.append(preload("res://Decors/Tree2.tscn"))
	tree_num = len(trees)

var range_val = 10

func _on_Timer_timeout():
	$Timer.start(rand_range(3 * (1 / GlobalSys.building_forward_speed), 6 * (1 / GlobalSys.building_forward_speed)))
	
	var tree = trees[round(rand_range(0, tree_num-1))].instance()
	
	if tree != null:
		get_parent().add_child(tree)
		tree.is_flipped = rand_range(-1, 1) > 0
		tree.global_position = global_position + Vector2(rand_range(-range_val, range_val), 0)
		
		var rc = []
		for _i in range(3):
			rc.append(rand_range(0.2, 1))
		rc.append(rand_range(0.6, 1))
		
		tree.modulate = Color(rc[0], rc[1], rc[2], rc[3])
