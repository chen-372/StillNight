extends CanvasLayer

var ups = [null, null]
var bullet_types = ["explosive", "lingering", "linker", "destructive"]
var dirs = ["right", "left", "up", "down", "up_left", "up_right", "down_right", "down_left"]

func _ready():
	if GlobalSys.game_time < 10:
		$ColorRect.modulate.a = 1
		
	GlobalSys.choosing_upgrades = true
	$ColorRect.modulate.a = 0
	get_tree().paused = true
	
	var temp = round(rand_range(0, len(GlobalSys.module_names) - 1))
	ups[0] = GlobalSys.module_names[temp]
	ups[1] = ups[0]
	while ups[0] == ups[1]:
		temp = round(rand_range(0, len(GlobalSys.module_names) - 1))
		ups[1] = GlobalSys.module_names[temp]
	
	
	for i in range(len(ups)):
		if ups[i] == GlobalSys.module_names[0]:
			ups[i] += "\n- acceleration: " + "+ " + "#" + str(round(rand_range(200, 1500))) + "#"
			ups[i] += "\n- max speed: " + "+ " + "#" + str(round(rand_range(100, 500))) + "#"
		elif ups[i] == GlobalSys.module_names[1]:
			var temp1 = str(dirs[round(rand_range(0, len(dirs) - 1))])
			var temp2 = str(dirs[round(rand_range(0, len(dirs) - 1))])
			ups[i] += "\n- enable auto-attack, direction:\n" + "#" + temp1 + "#\n" + "#" + temp2 + "#"
		elif ups[i] == GlobalSys.module_names[2]:
			var r = randf()
			var r2 = randf()
			temp = {
				true: "On",
				false: "Off"
			}
			if r2 < 0.333:
				temp = {
					true: "On",
					false: "On"
				}
			ups[i] += "\n- marginal Defense: " + "#" + temp[r >= 0.5] + "#"
			ups[i] += "\n- auto-evade: " + "#" + temp[r < 0.5] + "#, " + "detect radius: #" + str(rand_range(0.5, 1.5)) + "#" 
			
		elif ups[i] == GlobalSys.module_names[3]:
			ups[i] += "\n- change bullet type to: " + "#" + bullet_types[round(rand_range(0, len(bullet_types) - 1))] + "#"
		elif ups[i] == GlobalSys.module_names[4]:
			pass
	
	$ColorRect/Choice1.text = "\n\n" + ups[0]
	$ColorRect/Choice2.text = "\n\n" + ups[1]
	

func _process(delta):
	if $ColorRect.modulate.a < 1:
		$ColorRect.modulate.a += delta
		

func _on_Cancel_pressed():
	GlobalSys.choosing_upgrades = false
	get_tree().paused = false
	queue_free()


func _on_Equip_pressed():
	GlobalSys.choosing_upgrades = false
	get_tree().paused = false
	Playerstats.remove_upgrades()
	
	for i in range(len(ups)):
		if ups[i].count(GlobalSys.module_names[0]) == 1:
			Playerstats.acceleration = Playerstats.default_acceleration + int(ups[i].split("#")[1])
			Playerstats.max_speed = Playerstats.default_max_speed + int(ups[i].split("#")[1])
		elif ups[i].count(GlobalSys.module_names[1]) == 1:
			Playerstats.aim_dir[ups[i].split("#")[1]] = true
			Playerstats.aim_dir[ups[i].split("#")[3]] = true
		elif ups[i].count(GlobalSys.module_names[2]) == 1:
			var temp = {
				"On" : true,
				"Off" : false
			}
			Playerstats.marginal_defense = temp[ups[i].split("#")[1]]
			Playerstats.evade = temp[ups[i].split("#")[3]]
			Playerstats.detect_range = Vector2(float(ups[i].split("#")[5]), float(ups[i].split("#")[5]))
		elif ups[i].count(GlobalSys.module_names[3]) == 1:
			Playerstats.current_bullet_type = ups[i].split("#")[1]
			if Playerstats.current_bullet_type == "destructive":
				Playerstats.acceleration *= 0.7
		elif ups[i].count(GlobalSys.module_names[4]) == 1:
			pass
	
	Playerstats.upgrades[0] = ups[0]
	Playerstats.upgrades[1] = ups[1]
	
	queue_free()
