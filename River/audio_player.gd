extends Node2D

var audio_dict: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AudioStreamPlayer2D:
			audio_dict[child.name] = child

func play_random_sound(audio_stream_strings: Array, volume_db_min: float = -5, volume_db_max: float = 0, pitch_scale_min: float = 0.8, pitch_scale_max: float = 1.2):
	var audio_stream_string = audio_stream_strings.pick_random()
	play_sound(audio_stream_string, volume_db_min, volume_db_max, pitch_scale_min, pitch_scale_max)

func play_sound(audio_stream_string: String, volume_db_min: float = -5, volume_db_max: float = 0, pitch_scale_min: float = 0.8, pitch_scale_max: float = 1.2):
	var audio_stream = audio_dict.get(audio_stream_string)
	audio_stream.volume_db = randf_range(volume_db_min, volume_db_max)
	audio_stream.pitch_scale = randf_range(pitch_scale_min, pitch_scale_max)
	audio_stream.play()
	
func stop_sound(audio_stream_string: String):
	if audio_dict.has(audio_stream_string):
		audio_dict.get(audio_stream_string).stop()

func is_playing(audio_stream: String) -> bool:
	if audio_dict.has(audio_stream):
		return audio_dict.get(audio_stream).playing
	else:
		return false
