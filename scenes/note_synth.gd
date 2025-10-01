# Note.gd
class_name NoteSynth
extends RigidBody2D

enum NoteName { C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B }

@export var pitch: NoteName = NoteName.C
@export_range(0, 8, 1) var octave := 4
@export var duration_sec := 0.4

@onready var note_label: Label = $NoteLabel
@onready var note_sound := $NoteSound   # AudioStreamPlayer with NoteSound.gd

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)
	note_label.text = _name_str()

func _on_body_entered(_body: Node) -> void:
	note_sound.play_sine(_freq(), duration_sec)

# helpers
func _name_str() -> String:
	var names := ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"]
	return "%s%d" % [names[int(pitch)], octave]

func _freq() -> float:
	var midi := (octave + 1) * 12 + int(pitch)   # C4=60, A4=69
	return 440.0 * pow(2.0, float(midi - 69) / 12.0)
