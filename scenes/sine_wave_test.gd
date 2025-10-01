extends Node

var playback  # we'll store the buffer we can write numbers into

func _ready():
	# (1) Make a player node: this is the "speaker"
	var player = AudioStreamPlayer.new()
	add_child(player)

	# (2) Make a generator: this says "we'll create samples instead of using a .wav"
	var gen = AudioStreamGenerator.new()
	gen.mix_rate = 44100       # samples per second (CD quality)
	gen.buffer_length = 0.2    # how much audio (seconds) it can hold at once
	player.stream = gen        # attach generator to the player
	player.play()              # start playing

	# (3) Get the playback object: this is the actual buffer we can push numbers into
	playback = player.get_stream_playback()

	# (4) Choose a frequency: 440 Hz = concert A
	var freq = 440.0
	# How much the sine wave advances each sample
	var increment = TAU * freq / gen.mix_rate
	var phase = 0.0

	# (5) Generate one second of samples
	var frames = int(gen.mix_rate * 1.0)  # 1 second * 44100 samples
	for i in range(frames):
		var sample = sin(phase)   # the "number" for this instant, -1..1
		# push the sample into left & right channels (stereo)
		playback.push_frame(Vector2(sample, sample))
		phase += increment
