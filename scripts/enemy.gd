extends Node2D

const SPEED = 60
var direction = 1
var is_dead = false

# Added flag to let the killzone know this enemy is being defeated
var is_being_stomped = false

@export var linked_block: Node = null

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone: Area2D = $Killzone
@onready var kaboom_area: Area2D = $KaboomArea

func _ready() -> void:
	kaboom_area.body_entered.connect(_on_kaboom_area_body_entered)

func _process(delta: float) -> void:
	if is_dead or is_being_stomped:
		return
		
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	position.x += direction * SPEED * delta

func _on_kaboom_area_body_entered(body: Node) -> void:
	print("Kaboom Fired")
	if is_dead or is_being_stomped:
		return
		
	if body.is_in_group("player") and body.velocity.y > 0:
		# Set the flag immediately so the killzone collision check can read it
		is_being_stomped = true
		
		# Cleanly disable collision tracking areas 
		kaboom_area.set_deferred("monitoring", false)
		kaboom_area.get_node("CollisionShape2D").set_deferred("disabled", true)
		
		killzone.set_deferred("monitoring", false)
		if killzone.has_node("CollisionShape2D"):
			killzone.get_node("CollisionShape2D").set_deferred("disabled", true)
		
		# Bounce player up
		body.velocity.y = -200.0
		die()

func die() -> void:
	is_dead = true
	if linked_block:
		var roll = randi() % 3
		linked_block.reveal(roll)
	queue_free()
