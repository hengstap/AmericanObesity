extends Node2D

func _ready() -> void:
	# TODO: Load any persistent game assets and data

	# Call setup to any plugins?

	# TODO Much later: Set up ECS, message brokers / buses etc

	# TODO Much later: Show a splash screen with "Bloqsure Studios" logo, then fade to 
	# a main menu screen

	# TODO: Attach virtual audio interface, dispatch audio start event, 
	# start music playback

	main() 

func main() -> void:
	# TODO: Await signal / input from the user to change the active camera view to the 
	# arena where our main game happens.

	# TODO: Any prelude (i.e. show player controls, etc.)
	# TODO: Set a callback (i.e. player clicks/presses 'A' or 'Enter' to start the game)

	# TODO: Fire event that tells the reactor/event loop to start timers, and begin pushing 
	# behaviors onto message queue/bus. (For tower defense, this would mean start sending enemies)
	# But for a clicker game this is just a no-op event

	var i: int = 0;

	while true:
		# TODO: Derive the next reaction to take from the message/signal received.
		# Signals might include:
		# - Player clicked BurgerNode, therefore:
		#   - Play a sound
		#   - Increment the player's score
		#   - Push a request to the reactor/event loop to see if we gain new capabilities
		# - New power unlocked b/c score reached, therefore:
		#   - Play a sound
		#   - Update the UI to add a new permanent visual element, etc.
		#   - Update the mode on UI elements to change how many points they yield when clicked, etc.
		_process(0.016);
		i += 1;


# Called each frame, where `delta` (duration of `tick` on the ECS) is elapsed since the last frame
func _process(delta: float) -> void:
	return;
	# print("Time elapsed: ", delta);
