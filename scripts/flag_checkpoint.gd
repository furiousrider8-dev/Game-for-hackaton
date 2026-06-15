extends Node2D

@export var dialogue_message: String = ""
@export var spawn_offset: Vector2 = Vector2(-32, -16)
var activated: bool = false

func _on_body_entered(body: Node2D) -> void:
	if activated:
		return
	if body.is_in_group("player"):
		GameState.checkpoint_position = global_position + spawn_offset
		print("Checkpoint saved at: ", GameState.checkpoint_position)
		if dialogue_message != "":
			Dialogue_System.show_tutorial(dialogue_message)

func _on_body_exited(body: Node2D) -> void:
	print("children: ", get_children())
	print("area2d direct: ", $Area2D)
	if body.is_in_group("player") and not activated:
		activated = true
		Dialogue_System.show_checkpoint("Checkpoint\nSaved!")
		# Disable on the Area2D child, not this Node2D
		$Area2D.set_deferred("monitoring", false)
		$Area2D.set_deferred("monitorable", false)
