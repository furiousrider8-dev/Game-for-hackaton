extends CharacterBody2D

var SPEED = 150.0           
var JUMP_VELOCITY = -300.0  
var is_dead: bool = false
var is_invincible: bool = false

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector2.ZERO
		return
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

func apply_powerup(type: int) -> void:
	if is_dead: return
	match type:
		0:  # Speed
			SPEED += 100.0
			await get_tree().create_timer(10.0).timeout
			if is_instance_valid(self) and not is_dead:
				SPEED -= 100.0
		1:  # Jump
			JUMP_VELOCITY -= 200.0
			await get_tree().create_timer(10.0).timeout
			if is_instance_valid(self) and not is_dead:
				JUMP_VELOCITY += 200.0
		2:  # Invincibility
			apply_invincibility(10.0)

func apply_invincibility(duration: float) -> void:
	if is_dead: return
	is_invincible = true
	await get_tree().create_timer(duration).timeout
	if is_instance_valid(self) and not is_dead:
		is_invincible = false

func die() -> void:
	if is_invincible or is_dead:
		return
	is_dead = true
	velocity = Vector2.ZERO
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	animated_sprite.play("dead")
	await animated_sprite.animation_finished
	if not is_instance_valid(self):
		return
	# ← Removed respawn() call here entirely
	# Killzone timer is the ONLY caller of respawn()
	# If no checkpoint, reload — killzone timer won't fire respawn either
	if GameState.checkpoint_position == Vector2.ZERO:
		get_tree().reload_current_scene()

func respawn() -> void:
	velocity = Vector2.ZERO
	global_position = GameState.checkpoint_position
	is_dead = false
	SPEED = 150.0
	JUMP_VELOCITY = -300.0
	is_invincible = false
	animated_sprite.play("idle")
	Dialogue_System.reset_powerup()
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", false)
