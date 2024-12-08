extends Node

#Declare the NodePath variables for Area2D and Clickbutt nodes
@export var area_path: NodePath
@export var click_button_path: NodePath

#Cache the references
var area_node: Area2D
var click_button: Node

func _ready() -> void:
	# Get the Area2D node and connect its signal
	area_node = get_node(area_path) as Area2D
	if area_node:
		area_node.connect("area_entered", Callable(self, "_on_area_entered"))

	# Get the Clickbutt node and connect its signal
	click_button = get_node(click_button_path)
	if click_button:
		click_button.connect("click", Callable(self, "_on_click_butt_click"))

func _on_click_butt_click() -> void:
	print("Click event detected in Arena script")

func _on_area_entered(other_area: Node) -> void:
	print("An area entered:", other_area.name)
