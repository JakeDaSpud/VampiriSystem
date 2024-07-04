extends Control

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/Main Menu.tscn")

func _on_yt_link_pressed():
	OS.shell_open("https://www.youtube.com/@jakeoreilly")

func _on_twitter_link_pressed():
	OS.shell_open("https://twitter.com/jor_gamedev")
