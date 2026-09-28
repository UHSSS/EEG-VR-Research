extends Node3D

@export var player: Player
@export var experiments: Array[Experiment]
@export var task_reference_node: Node3D

var recording: bool = false
var timer: float = 0

var cur_experiment: Experiment
var cur_experiment_idx: int = 0
var cur_experiment_node: Node

func _physics_process(delta: float) -> void:
	if not recording: return
	if timer > 0:
		timer -= delta
	elif timer <= 0 and not cur_experiment.manual_stop:
		toggle_recording()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_recording"):
		toggle_recording()

func toggle_recording() -> void:
	if not recording:
		print("---------- Begin %s Experiment ----------" % cur_experiment.experiment_name)
		cur_experiment = experiments[cur_experiment_idx]
		timer = cur_experiment.experiment_duration
		cur_experiment_node = Utils.create_child(cur_experiment.task_node, task_reference_node)
		player.recenter_headset()
		recording = true
		Globals.send_galea_marker(cur_experiment.start_marker)
	else:
		cur_experiment_node.queue_free()
		recording = false
		Globals.send_galea_marker(Experiment.MARKER.STOP_RECORDING)
		cur_experiment_idx = clampi(cur_experiment_idx + 1, 0, experiments.size() - 1)
		print("---------- End %s Experiment ----------" % cur_experiment.experiment_name)
