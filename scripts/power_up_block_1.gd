# powerup_block.gd
extends Area2D

var is_revealed = false
var powerup_type = -1
var player_nearby = false
var player_ref = null

const POWERUP_NAMES = {
	0: "Speed Boost",
	1: "Jump Boost", 
	2: "Invincibility"
}
const DURATION = 10.0

@onready var label: Label = $Label                    # "Press E to interact"
@onready var dialogue: Label = $Dialogue              # "You have gained..."
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	label.hide()
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func reveal(type: int) -> void:
	powerup_type = type
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func _process(delta: float) -> void:
	if is_revealed:
		return
	if player_nearby and Input.is_action_just_pressed("interact"):
		_collect()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		player_ref = body
		label.show()

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_nearby = false
		player_ref = null
		label.hide()

func _collect() -> void:
	is_revealed = true
	label.hide()
	$Sprite2D.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	audio.play()
	_apply_powerup(player_ref)
	await get_tree().create_timer(3.0).timeout
	await audio.finished
	queue_free()

func _apply_powerup(body: Node) -> void:
	match powerup_type:
		0:  # Speed
			body.SPEED += 100.0
			await get_tree().create_timer(DURATION).timeout
			body.SPEED -= 100.0
		1:  # Jump
			body.JUMP_VELOCITY -= 200.0
			await get_tree().create_timer(DURATION).timeout
			body.JUMP_VELOCITY += 200.0
		2:  # Invincibility
			body.is_invincible = true
			await get_tree().create_timer(DURATION).timeout
			body.is_invincible = false
