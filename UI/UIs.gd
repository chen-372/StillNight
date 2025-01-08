extends Node2D

func _ready():
	$Label2.text = "Damage Bonus: " + str(Playerstats.speed_damage_bonus)
	$show_upgrade/ColorRect.visible = false


func is_choosing_upgrades(switch):
	$BatteryUI.visible = !switch
	$Label.visible = !switch
	$Label2.visible = !switch
	$Label3.visible = !switch
	$paused_sign.visible = !switch


func _process(_delta):
	$Label.text = "Points: " + str(GlobalSys.player_points)
	$Label3.text = "Duration: " + str(GlobalSys.game_time)
	$show_upgrade/ColorRect/RichTextLabel.text = Playerstats.upgrades[0] + "\n\n\n\n" + Playerstats.upgrades[1]
	is_choosing_upgrades(GlobalSys.choosing_upgrades)
	if GlobalSys.choosing_upgrades:
		$show_upgrade/ColorRect.visible = true
	
	if $show_upgrade/ColorRect.visible && get_tree().paused == false:
		$show_upgrade/ColorRect.visible = false
	
	$paused_sign.visible = get_tree().paused && !GlobalSys.choosing_upgrades
	

func _on_update_speed_timeout():
	Playerstats.speed_damage_bonus = clamp(round(0.5 * (abs(Playerstats.velocity.x) + abs(Playerstats.velocity.y))) * 0.01, 0, 6.00)
	if Playerstats.current_bullet_type == "destructive":
		$Label2.text = "Damage Bonus (charging): " + str(Playerstats.sniper_damage)
	else:
		$Label2.text = "Damage Bonus: " + str(Playerstats.speed_damage_bonus)

func _on_show_upgrade_pressed():
	$show_upgrade/ColorRect.visible = !$show_upgrade/ColorRect.visible
	get_tree().paused = !get_tree().paused
