class_name Utils
extends Node

static func create_child(scene: PackedScene, parent: Node) -> Node:
	var node: Node = scene.instantiate()
	parent.add_child(node)
	return node
