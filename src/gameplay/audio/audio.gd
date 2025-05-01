extends Node

var count_of_players: int = 10
var players: Array[AudioStreamPlayer]

func _ready() -> void:
	for index in count_of_players:
		var stream = AudioStreamPlayer.new()
		add_child(stream)
		players.append(stream)
		stream.finished.connect(_on_audio_finished.bind(stream))

func _on_audio_finished(stream: AudioStreamPlayer) -> void:
	players.append(stream)

func play(path: String, pitch_range: Vector2 = Vector2(0.9, 1.1)) -> void:
	var player = players.pop_front()
	player.stream = load(path)
	player.play()
	player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
