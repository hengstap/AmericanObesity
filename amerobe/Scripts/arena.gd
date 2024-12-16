extends Node2D

# Game state variables
var weight_lbs: float = 150.0  # Starting weight
var weight_cals: float = 0.0   # Calorie counter
const CALORIES_PER_POUND: float = 3500.0

# Onready variables for UI elements
@onready var weight_label: Label = $UIBackground/VBoxContainer/WeightLabel
@onready var calories_label: Label = $UIBackground/VBoxContainer/CaloriesLabel

func _ready() -> void:
	setup_ui()
	setup_buttons()
	update_ui()

func setup_ui() -> void:
	# Set up weight label
	if weight_label:
		weight_label.text = "Weight: %0.1f lbs" % weight_lbs
		theme_override_font_sizes(weight_label, 36)
	
	# Set up calories label
	if calories_label:
		calories_label.text = "Calories: %0.1f / %0.1f" % [weight_cals, CALORIES_PER_POUND]
		theme_override_font_sizes(calories_label, 30)

func theme_override_font_sizes(label: Label, size: int) -> void:
	# In Godot 4.x, we use theme overrides for font size
	label.add_theme_font_size_override("font_size", size)

func setup_buttons() -> void:
	# Food button data: calories and cooldown time
	var food_data = [
		{"calories": 150.0, "cooldown": 1.0},  # FoodButton1
		{"calories": 300.0, "cooldown": 3.0},  # FoodButton2
		{"calories": 500.0, "cooldown": 5.0}   # FoodButton3
	]
	
	# Set up each button
	for i in range(3):
		var button_path = "FoodButton%d" % (i + 1)
		var button = get_node_or_null(button_path)
		
		if button:
			# Store metadata
			button.set_meta("calories", food_data[i]["calories"])
			button.set_meta("cooldown", food_data[i]["cooldown"])
			
			# Connect signal
			button.pressed.connect(_on_food_button_pressed.bind(button))

func _on_food_button_pressed(button: TextureButton) -> void:
	# Get calories from button metadata
	var calories = button.get_meta("calories", 0.0)
	
	# Add calories and update weight if necessary
	weight_cals += calories
	while weight_cals >= CALORIES_PER_POUND:
		weight_lbs += 1.0
		weight_cals -= CALORIES_PER_POUND
	
	# Update UI
	update_ui()
	
	# Play effects
	play_button_effects(button)

func play_button_effects(button: TextureButton) -> void:
	# Play sound effect
	var sound_player = button.get_node_or_null("ButtonSound")
	if sound_player:
		sound_player.play()
	
	# Play flash animation
	var flash_sprite = button.get_node_or_null("FlashSprite")
	if flash_sprite:
		flash_sprite.visible = true
		flash_sprite.play("flash")
		
		# Create timer for hiding flash
		var timer = get_tree().create_timer(0.2)
		await timer.timeout
		flash_sprite.visible = false

func update_ui() -> void:
	# Update weight display
	if weight_label:
		weight_label.text = "Weight: %0.1f lbs" % weight_lbs
	
	# Update calories display
	if calories_label:
		calories_label.text = "Calories: %0.1f / %0.1f" % [weight_cals, CALORIES_PER_POUND]
