extends Area2D

@onready var timer = $Timer
@onready var die: AudioStreamPlayer = %die


func _on_body_entered(body):
	print("You Died!")
	Engine.time_scale = 0.5
	body.die() 
	$CollisionShape2D.queue_free()
	%die.play()
	timer.start()


func _on_timer_timeout() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
