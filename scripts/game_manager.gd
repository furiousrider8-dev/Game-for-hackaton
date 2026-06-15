extends Node

# game_manager.gd (autoload)
# game_manager.gd — add these two lines at the top
var checkpoint_position: Vector2 = Vector2.ZERO
var first_coin_collected: bool = false

func reset_checkpoint() -> void:
	checkpoint_position = Vector2.ZERO
	
var score = 0
@onready var var_label: Label = $VarLabel

func add_point():
	score += 1
	var_label.text = "You collected " + str(score) + " coins."
