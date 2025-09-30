class_name Player
extends CharacterBody2D

@export var SPEED := 200

func _physics_process(delta: float) -> void:
	# handle movement
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * SPEED
	move_and_slide()
	# find collisions
	for i in get_slide_collision_count():
		var collided_object = get_slide_collision(i).get_collider()
		var collision_normal = get_slide_collision(i).get_normal()
		collided_object.apply_central_impulse(-collision_normal)
