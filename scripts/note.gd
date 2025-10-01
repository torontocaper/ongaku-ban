class_name Note
extends RigidBody2D

@export var note_name : String

@onready var note_label: Label = $NoteLabel
@onready var note_sound: AudioStreamPlayer = $NoteSound

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	note_label.text = note_name

func _on_body_entered(_body: Node) -> void:
	print_debug("body entered")
	if not note_sound.playing:
		print_debug("Playing sound")
		note_sound.play()
