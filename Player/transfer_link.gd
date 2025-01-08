extends Line2D

var init_finished = false

func _ready():
	modulate.a = 0

func _process(delta):
	points[0] = $Position1.position
	points[1] = $Position2.position
	
	if init_finished == false:
		shade_in(delta)

func shade_in(delta):
	modulate.a += delta
	if modulate.a >= 1:
		init_finished = true

func shade_out():
	modulate.a -= 0.01
	if modulate.a <= 0:
		queue_free()	
		if get_parent().get_node("Enemystats"):
			get_parent().get_node("Enemystats").linked = false
