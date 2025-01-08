extends Position2D

const Enemy1 = preload("res://Enemy/Enemy1/Enemy1.tscn")
const Enemy2 = preload("res://Enemy/Enemy2/Enemy2.tscn")
const Boss1 = preload("res://Enemy/Boss1/boss1.tscn")

var enemyList = [Enemy1, Enemy2]
var enemy_num = 0
var init_building_forward_speed = 0
var type_max_count = 3

func _ready():
	init_building_forward_speed = GlobalSys.building_forward_speed
	enemy_num = len(enemyList)

func _on_Timer_timeout():
	$Timer.start(rand_range(6, 15 - GlobalSys.building_forward_speed * 0.4))

	if GlobalSys.pause_all_spawn:
		if GlobalSys.boss_exist == false:
			var boss1 = Boss1.instance()
			get_parent().get_parent().add_child(boss1)
			boss1.global_position = Vector2(704, 320)

		return

	for _i in range(round(rand_range(GlobalSys.building_forward_speed / GlobalSys.max_building_forward_speed, GlobalSys.building_forward_speed * 0.55))):
		var rand_num = round(rand_range(0, enemy_num - 1))

		var enemy = enemyList[rand_num].instance()

		if rand_num == 0 && get_parent().get_parent().get_node("Enemy1").get_child_count() <= type_max_count:
			var tmp = 100
			get_parent().get_parent().get_node("Enemy1").add_child(enemy)
			enemy.global_position = position + Vector2(rand_range(-tmp, tmp), rand_range(-tmp, tmp))
			
		elif rand_num == 1 && get_parent().get_parent().get_node("Enemy2").get_child_count() <= type_max_count:
			get_parent().get_parent().get_node("Enemy2").add_child(enemy)
			enemy.global_position.x = position.x + rand_range(0, 600)
			enemy.global_position.y = $Enemy2Pos.global_position.y
	
	
