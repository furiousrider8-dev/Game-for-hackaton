extends CharacterBody2D

var SPEED = 150.0           
var JUMP_VELOCITY = -300.0  

var is_invincible: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func apply_invincibility(duration: float) -> void:
	is_invincible = true
	var tween = create_tween().set_loops()
	tween.tween_property(self, "modulate", Color(1, 1, 0, 0.5), 0.15)
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
	await get_tree().create_timer(duration).timeout
	is_invincible = false
	modulate = Color.WHITE
	tween.kill()

func die() -> void:
	if is_invincible:
		return                      
	set_physics_process(false)
	animated_sprite.play("dead")
	await animated_sprite.animation_finished
	get_tree().reload_current_scene()
