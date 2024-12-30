extends Node2D

signal evolution_complete

# Pokemon-style evolution animation
func _ready() -> void:
	setup_evolution_animation()
	play_evolution_sequence()

func setup_evolution_animation() -> void:
	# Set up your sprite frames for the evolution animation
	# Similar to Pokemon evolution effect with flash and transform
	var animation_player = $AnimationPlayer
	animation_player.connect("animation_finished", _on_evolution_complete)

func play_evolution_sequence() -> void:
	# Play evolution sound
	$EvolutionSound.play()
	# Start the animation sequence
	$AnimationPlayer.play("evolve")

func _on_evolution_complete(_anim_name: String) -> void:
	# Wait for sound to finish
	await $EvolutionSound.finished
	# Tell scene manager to proceed
	SceneManager.finish_evolution()
