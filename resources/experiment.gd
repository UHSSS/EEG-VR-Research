class_name Experiment
extends Resource

enum MARKER { 
		STOP_RECORDING = 1,
		START_RECORDING_REST = 8, 
		START_RECORDING_BREATHING = 7,
		START_RECORDING_BODY_SCAN = 6,
		START_RECORDING_SUSTAINED_ATTENTION = 5,
	}

@export var experiment_name: String
## How long the given experiment should last
@export var experiment_duration: int = 600
## Flag to not automatically end the experiment when the timer expires
@export var manual_stop: bool = false
## Which marker to send to Galea GUI for this experiment
@export var start_marker: MARKER = MARKER.START_RECORDING_REST
## The scene to spawn in when the task starts
@export var task_node: PackedScene
