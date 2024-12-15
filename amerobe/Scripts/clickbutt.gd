class_name Clickbutt
extends Area2D  # Use Area2D to detect input events

signal click  # Signal to notify a click event

@export var score: int = 0  # Track clicks
@export var is_mouseover: bool = false
@export var quit: bool = false
@export var _quit_complete: bool = false

func _ready() -> void:
	# Connect mouse events
	self.connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	# Detect left mouse click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		score += 1
		print("Score: ", score)
		emit_signal("click")  # Emit the click signal when clicked

func _mouse_enter() -> void:
	is_mouseover = true
	print("Mouse entered button area")

func _mouse_exit() -> void:
	is_mouseover = false
	print("Mouse exited button area")
