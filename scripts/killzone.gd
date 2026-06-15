extends Area2D

@onready var timer = $Timer
@onready var die: AudioStreamPlayer = %die
@export var is_void: bool = false

var triggered: bool = false

func _on_body_entered(body):
	print("Killzone Fired")
	if triggered:
		return
		
	var enemy_parent = get_parent()
	if enemy_parent and "is_being_stomped" in enemy_parent:
		if enemy_parent.is_being_stomped:
			return 
	
	if body.is_in_group("player"):
		if body.is_invincible and not is_void:
			return
		triggered = true
		print("You Died!")
		Engine.time_scale = 0.5
		body.is_invincible = false
		Dialogue_System.reset_powerup()
		body.die()
		if not is_void:
			$CollisionShape2D.queue_free()
		die.play()
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	triggered = false
	if GameState.checkpoint_position != Vector2.ZERO:
		var player = get_tree().get_first_node_in_group("player")
		if is_instance_valid(player):
			
			if is_void:
				monitoring = false
			player.respawn()
			if is_void:
				await get_tree().create_timer(0.5).timeout
				monitoring = true
	else:
		get_tree().reload_current_scene()
