# Filename: res://clickbutt.gd
"""md
# Clickbutt
---
> Official documentation for its inherited
> functionality can be found at https://docs.godotengine.org/en/latest/classes/class_collisionobject2d.html
## Description:
	TODO
## Properties:
	TODO
	> Inherited from [CollisionObject2D](https://docs.godotengine.org/en/latest/classes/class_collisionobject2d.html#properties)
"""

extends CollisionShape2D

signal click
# TODO: Make `score` a read-only view of a protected engine-backed `score`.
# `score` is the number of clicks the player has made + the number of artificial clicks
# made by the environment.
@export var score: int = 0
@export var is_mouseover: bool = false
@export var quit: bool = false
@export var _quit_complete: bool = false

# If true, this object is pickable. 
# A pickable object can detect the mouse pointer entering/leaving, and if the mouse is inside it, 
# report input events. 
# **Requires at least one collision_layer bit to be set.**
# Able to be modified by getter and setter functions.
var is_pickable: bool = true;

"""
Accepts unhandled InputEvents. shape_idx is the child index of the clicked Shape2D. 
Connect to input_event to easily pick up these events.
Note: _input_event() requires input_pickable to be true and at least one collision_layer bit to be set.
"""
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if !is_mouseover:
		return
	if Input.is_action_pressed(&"left_click", true):
		click.emit()

func fire_click() -> bool:
	return true
 
func _mouse_enter() -> void:
	is_mouseover = true

func _mouse_exit() -> void:
	is_mouseover = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	print("We made it")
	while true:
		pass
	# _quit_complete = await run_scoring_loop()
	

func run_scoring_loop() -> bool:
	# TODO: Move this logic to a message broker
	# TODO: Load initial value from save data
	while !quit:
		print("Running the clicker program")
		await Signal(self, 'click')
		score += 1
		print("Click received!")
	return true
