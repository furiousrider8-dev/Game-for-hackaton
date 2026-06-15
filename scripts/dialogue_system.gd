extends CanvasLayer

signal dialogue_closed

@onready var panel: NinePatchRect = $Panel
@onready var message_label: Label = $Panel/MessageLabel
@onready var continue_label: Label = $Panel/ContinueLabel
@onready var powerup_panel: NinePatchRect = $PowerupPanel
@onready var powerup_label: Label = $PowerupPanel/PowerupLabel
@onready var checkpoint_panel: NinePatchRect = $CheckpointPanel
@onready var checkpoint_label: Label = $CheckpointPanel/CheckpointLabel

var is_showing: bool = false
var is_powerup: bool = false
var countdown: float = 0.0
var powerup_name: String = ""

func _ready() -> void:
	panel.hide()
	powerup_panel.hide()
	checkpoint_panel.hide()

func show_tutorial(message: String) -> void:
	if is_showing:
		return
	is_showing = true
	message_label.text = message
	panel.show()
	get_tree().paused = true

func show_powerup(powerup: String, duration: float) -> void:
	powerup_name = powerup
	countdown = duration
	is_powerup = true
	powerup_panel.show()
	
func reset_powerup() -> void:
	is_powerup = false
	countdown = 0.0
	powerup_name = ""
	powerup_panel.hide()
	
func _process(delta: float) -> void:
	# Tutorial dismiss
	if is_showing:
		if Input.is_action_just_pressed("interact") or \
		   Input.is_action_just_pressed("jump"):
			_close_tutorial()
	# Powerup countdown
	if is_powerup:
		countdown -= delta
		countdown = max(countdown, 0.0)
		powerup_label.text = "You got %s!\n%ds remaining" % \
			[powerup_name, int(countdown)]
		if countdown <= 0.0:
			is_powerup = false
			powerup_panel.hide()

func show_checkpoint(message: String) -> void:
		checkpoint_label.text = message
		checkpoint_panel.show()
		await get_tree().create_timer(3.0).timeout
		checkpoint_panel.hide()

func _close_tutorial() -> void:
	is_showing = false
	panel.hide()
	get_tree().paused = false
	dialogue_closed.emit()
