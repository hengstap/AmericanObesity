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
class_name Clickbutt
extends CollisionShape2D

signal click
# TODO: Make `score` a read-only view of a protected engine-backed `score`.
# `score` is the number of clicks the player has made + the number of artificial clicks
# made by the environment.
@export var score: int = 0
@export var is_mouseover: bool = false
@export var quit: bool = false
@export var _quit_complete: bool = false
var collider: CollisionObject2D = $CollisionObject2D
# If true, this object is pickable. 
# A pickable object can detect the mouse pointer entering/leaving, and if the mouse is inside it, 
# report input events. 
# **Requires at least one collision_layer bit to be set.**
# Able to be modified by getter and setter functions.
# var is_pickable: bool = true;

"""
Accepts unhandled InputEvents. shape_idx is the child index of the clicked Shape2D. 
Connect to input_event to easily pick up these events.
Note: _input_event() requires input_pickable to be true and at least one collision_layer bit to be set.
"""
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_pressed(&"left_click", true):
		score += 1
		print(score)

 
func _mouse_enter() -> void:
	self.set_collision_mask_value(1, true)

func _mouse_exit() -> void:
	is_mouseover = false



func _process(_delta: float) -> void:
	pass 
	
