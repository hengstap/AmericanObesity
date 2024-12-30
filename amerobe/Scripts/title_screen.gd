extends Node2D

#func _ready() -> void:
	# Setup title screen UI
#	setup_ui()
	# Play background music
#	setup_audio()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes//main.tscn")
