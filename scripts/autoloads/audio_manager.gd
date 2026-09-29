extends Node
## The AudioManager is an autoload script that centrally handles all things audio.
## All SFX are loaded into here and can be accessed by used by any other script.
## Also provides several audio playback functions.

# TODO: AUTO IMPORT FROM FOLDER FOR A GIVEN SET OF SFX
const MUSIC_BOX_POSITIVE = preload("uid://ujtc2cg47qq6")

var master_volume: float = 1.0
var music_volume: float = 0.5
var sfx_volume: float = 0.5
var ambience_volume: float = 0.5
var flute_volume: float = 0.5


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func set_volume(mixer: String, volume: float) -> float:
	var bus_idx := AudioServer.get_bus_index(mixer)
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))
	return volume


## Plays a preloaded audio stream by generating a player for it and destroying it on completion.[br]
## [param file]: The audio stream being loaded in, ie [code]AudioManager.FOOTSTEP1[/code][br]
## [param mixer]: The bus to play this sound from. Can be SFX, Music, or Master.[br]
## [param volume]: The volume (in relative terms, not decibels) to play the sound at.[br]
## [param pitch]: Whether or not to randomize the pitch for this sound.
func play_file(file: AudioStream, mixer: String = "SFX", volume: float = 1, pitch: bool = false) -> void:
	var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
	audio_player.stream = file
	audio_player.bus = mixer
	audio_player.volume_db = linear_to_db(volume)
	add_child(audio_player)
	if pitch:
		audio_player.pitch_scale += randf_range(-0.15, 0.15)
	audio_player.play()
	await audio_player.finished
	remove_child(audio_player)
	audio_player.queue_free()


## Picks a random sound from a predefined list and plays it.[br]
## [param list]: A list of preloaded audio streams. This would typically a list of sounds
## grouped into a predefined array.
## [param volume]: The volume (relative, not in decibels) to play this audio at.
## [param player]: The player to play this audio from. If left blank, will make a new temporary player.
func play_random(list: Array[AudioStream], volume := 1.0, player: AudioStreamPlayer3D = null) -> void:
	var track: AudioStream = list.pick_random()
	if player:
		player.stream = track
		player.play()
	else:
		play_file(track, "SFX", volume)


func fade_track(player: AudioStreamPlayer, from_vol := player.volume_linear, to_vol := 0.0, t := 1.0) -> void:
	player.volume_linear = from_vol
	var play_tween := get_tree().create_tween()
	play_tween.tween_property(player, "volume_linear", to_vol, t)
	await play_tween.finished
