extends Control

# Begin New Game
func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_00_Car.tscn")

# Switch to Settings Menu
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/Settings Menu.tscn")

# Open Credits Popup
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/Credits Menu.tscn")

# Quit Game
func _on_quit_pressed():
	get_tree().quit()
