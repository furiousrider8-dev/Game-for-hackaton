extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	animation_player.play("pickup")
	if not game_manager.first_coin_collected:
		game_manager.first_coin_collected = true
		Dialogue_System.show_tutorial("Collect coins to \nincrease your level \nand buy new skins!")
