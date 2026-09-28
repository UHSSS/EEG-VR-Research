class_name Player
extends XROrigin3D

@export var camera: XRCamera3D


# Resets position and orientation to the center of the room.
func recenter_headset():
	print("Recentering Headset.")
	#player.position = Vector3(0,0,0);
	rotation = Vector3(0,0,0);
	# Necessary since the headset camera is separate from the player origin node.
	# Built in function that resets and consolidates differences.
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT, true);
