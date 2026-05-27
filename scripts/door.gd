
extends Area2D

@export var next_scene: String = "res://scenes/Lvl2.tscn"
var player_nearby: bool = false

@onready var label: Label = $Label

func _ready() -> void:
	label.hide()

func _process(delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file(next_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		label.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		label.hide()
