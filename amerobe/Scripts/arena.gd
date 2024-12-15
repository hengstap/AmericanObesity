extends Node2D

# Variables for game state
var weight: int = 130

# Called when the scene is ready
func _ready():
	setup_buttons()
	update_ui()

# Setup buttons with metadata and timers
func setup_buttons():
	# Example calorie values and times for each button
	var food_data = [
		{"calories": 1, "time": 2.0},  # FoodButton1
		{"calories": 2, "time": 3.0},  # FoodButton2
		{"calories": 4, "time": 5.0}   # FoodButton3
	]
	
	for i in range(3):
		var button = get_node("FoodButton" + str(i + 1))
		var timer = button.get_node("Timer")  # Access the Timer child of each button
		
		# Set metadata for calories and timer duration
		button.set_meta("calories", food_data[i]["calories"])
		button.set_meta("time", food_data[i]["time"])
		
		# Configure the Timer node
		timer.wait_time = food_data[i]["time"]
		timer.one_shot = true
		timer.connect("timeout", Callable(self, "_on_timer_finished").bind(button))  # Bind the button to the timeout event
		
		# Connect button press to start the timer
		button.connect("pressed", Callable(self, "_on_food_button_pressed").bind(button))

# Called when a food button is pressed
func _on_food_button_pressed(button: TextureButton):
	var timer = button.get_node("Timer")  # Access the button's Timer child
	
	# Disable the button while the timer is active
	button.disabled = true
	timer.start()  # Start the eating timer
	
	# Optional: Provide feedback
	print("Eating started for:", button.name)

# Called when a timer finishes
func _on_timer_finished(button: TextureButton):
	if button.has_meta("calories"):
		weight += button.get_meta("calories")
		update_ui()
	
	# Re-enable the button after eating
	button.disabled = false
	
	# Optional: Provide feedback
	print("Eating finished for:", button.name)

# Update the UI with the current weight
func update_ui():
	$UI.text = "[center]Weight: " + str(weight) + " lbs[/center]"
