extends Position2D

var Building_List = []
var building_num = 0
var last_index = 0

func _ready():
	Building_List.append(preload("res://Structure/Building_1.tscn"))
	Building_List.append(preload("res://Structure/Building_2.tscn"))
	Building_List.append(preload("res://Structure/Building_3.tscn"))
	Building_List.append(preload("res://Structure/Building_4.tscn"))
	Building_List.append(preload("res://Structure/Building_5.tscn"))
	Building_List.append(preload("res://Structure/Building_6.tscn"))
	Building_List.append(preload("res://Structure/Building_7.tscn"))
	building_num = len(Building_List)

func _on_Timer_timeout():
	$Timer.start(rand_range(4 * (1 / GlobalSys.building_forward_speed), 10.5 * (1 / GlobalSys.building_forward_speed)))
	
	if GlobalSys.pause_all_spawn:
		return
		
	var index = 0
	while index == last_index:
		index = round(rand_range(0, building_num - 1))
	last_index = index
	
	var building = Building_List[index].instance()
	get_parent().add_child(building)
	building.global_position = global_position
