extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(load_next_level)

func load_next_level(body):
	if (body.is_in_group("Player_Group")):
		get_tree().change_scene_to_file("res://world.tscn")
