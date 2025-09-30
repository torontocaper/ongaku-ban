class_name Note
extends RigidBody2D

@export var note_name : String

func _physics_process(delta: float) -> void:
	if linear_velocity:
		print_debug("Note %s is moving at %s" % [note_name, str(linear_velocity)])
