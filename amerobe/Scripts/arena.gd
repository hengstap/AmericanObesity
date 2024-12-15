extends Node2D

# Variables for game state
var weight_lbs: int = 150
var weight_cals: int = 0  # Start calorie counter at 0

# Called when the scene is ready
func _ready():
	setup_buttons()
	update_ui()

# Setup buttons with metadata
func setup_buttons():
	var food_data = [
		{"calories": 150, "time": 1.0},
		{"calories": 300, "time": 3.0},
		{"calories": 500, "time": 5.0}
	]
	
	for i in range(3):
		var button = get_node("FoodButton" + str(i + 1))  # Ensure node paths are correct
		button.set_meta("calories", food_data[i]["calories"])
		button.connect("pressed", Callable(self, "_on_food_button_pressed").bind(button))  # Pass button explicitly

# Called when a food button is pressed
func _on_food_button_pressed(button: TextureButton):
	print("Button pressed:", button.name)  # Debugging
	var calories = button.get_meta("calories", 0)
	weight_cals += calories

	# Check if calorie counter has reached 3500 (1 lb)
	if weight_cals >= 3500:
		weight_lbs += 1  # Add a pound
		weight_cals -= 3500  # Reset calorie counter but keep any overflow

	update_ui()

	# Play sound
	var sound_player = button.get_node("ButtonSound")
	sound_player.play()

	# Play flash animation
	var flash_sprite = button.get_node("FlashSprite")
	flash_sprite.visible = true
	flash_sprite.play("flash")
	await get_tree().create_timer(0.2).timeout
	flash_sprite.visible = false

# Update the UI with the current weight
func update_ui():
	$UI.text = "[center]Weight: " + str(weight_lbs) + " lbs[/center]\n[center]Calories: " + str(weight_cals) + "/3500 cals[/center]"
