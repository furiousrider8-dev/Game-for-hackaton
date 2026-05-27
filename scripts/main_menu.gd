extends Node2D

@onready var music: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Lvl1.tscn")
