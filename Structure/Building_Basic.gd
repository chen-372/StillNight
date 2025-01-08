extends KinematicBody2D

var velocity = Vector2.ZERO

onready var screenPos = $ScreenPos
onready var objectDetectionZone = $ObjectDetectionZone

func _ready():
	var scr_count = screenPos.get_child_count()
	
	for _i in range(round(rand_range(0, scr_count))):
		screenPos.get_child(rand_range(0, scr_count)).queue_free()
	
	if $AnimatedSprite.frames.get_frame_count("sprite") > 1:
# warning-ignore:narrowing_conversion
		$AnimatedSprite.frame = round(rand_range(0, $AnimatedSprite.frames.get_frame_count("sprite")))
	
func _physics_process(_delta):
	get_parent().global_position.x -= GlobalSys.building_forward_speed
	
	if objectDetectionZone.object_detect() != null:
		objectDetectionZone.object_detect().queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()
