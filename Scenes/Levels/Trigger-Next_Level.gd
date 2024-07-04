extends Area3D

var levelIndex : int
var nextLevelIndex : int

# Called when the node enters the scene tree for the first time.
func _ready():
	levelIndex = get_tree().root.get_child(0).name.substr(5,8).to_int()
	nextLevelIndex = levelIndex + 1
	
	print("Current Level Index = ", levelIndex)
	print("Next Level Index = ", nextLevelIndex)
	body_entered.connect(load_next_level)

func load_next_level(body):
	if (body.is_in_group("Player_Group")):
		print("Trying to Load Level: ", nextLevelIndex)
		
		if (nextLevelIndex == 99):
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_99_Example.tscn")
		elif (nextLevelIndex == 0):
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_00_Car.tscn")
		elif (nextLevelIndex == 1):
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_01_Gates.tscn")
		elif (nextLevelIndex == 2):
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_02_Prison.tscn")
		else:
			print("Invalid Next Level Index")
			get_tree().change_scene_to_file("res://Scenes/Levels/Level_99_Example.tscn")
