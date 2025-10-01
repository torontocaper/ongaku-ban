# NoteSound.gd
extends AudioStreamPlayer

@export var mix_rate := 44100
@export var buffer_length := 0.2
@export var default_fade_ms := 5.0

var _pb: AudioStreamGeneratorPlayback

func _ready():
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = mix_rate
	gen.buffer_length = buffer_length
	stream = gen
	play()                    # start device so we can push samples
	_pb = get_stream_playback()

func play_sine(freq: float, seconds: float, fade_ms: float = -1.0) -> void:
	if _pb == null or seconds <= 0.0: return
	if fade_ms < 0.0: fade_ms = default_fade_ms
	var sr := float(mix_rate)
	var total := int(seconds * sr)
	var inc := TAU * freq / sr
	var phase := 0.0
	var fade : float = max(1, int((fade_ms / 1000.0) * sr))
	var t := 0
	while t < total:
		var avail := _pb.get_frames_available()
		if avail <= 0:
			await get_tree().process_frame
			continue
		var n : int = min(avail, total - t)
		for i in range(n):
			var s := sin(phase)
			if t < fade: s *= float(t) / float(fade)                  # fade-in
			elif t > total - fade: s *= float(total - t) / float(fade) # fade-out
			_pb.push_frame(Vector2(s, s))
			phase += inc
			t += 1
