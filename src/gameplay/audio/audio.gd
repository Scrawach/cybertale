extends Node

var count_of_players: int = 10
var players: Array[AudioStreamPlayer]
var playing_sounds: Dictionary[String, int]

func _ready() -> void:
	for index in count_of_players:
		var stream = AudioStreamPlayer.new()
		add_child(stream)
		players.append(stream)
		stream.finished.connect(_on_audio_finished.bind(stream))

func _on_audio_finished(stream: AudioStreamPlayer) -> void:
	players.append(stream)
	var path = get_cached_sound(stream.get_instance_id())
	playing_sounds.erase(path)

func get_cached_sound(instance_id: int) -> String:
	for path in playing_sounds.keys():
		if playing_sounds[path] == instance_id:
			return path
	return ""

func play(path: String, pitch_range: Vector2 = Vector2(0.9, 1.1)) -> void:
	var player: AudioStreamPlayer = players.pop_front() as AudioStreamPlayer
	player.stream = load(path)
	player.play()
	player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	playing_sounds[path] = player.get_instance_id()
