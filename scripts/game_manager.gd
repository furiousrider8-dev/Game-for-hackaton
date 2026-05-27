extends Node

var score = 0
@onready var var_label: Label = $VarLabel

func add_point():
	score += 1
	var_label.text = "You collected " + str(score) + " coins."
