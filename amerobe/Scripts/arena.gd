extends Node2D

# Signals
signal calories_added(amount: float)
signal weight_changed(new_weight: float)

# Game state variables
var weight_lbs: float = 150.0  # Starting weight
var weight_cals: float = 0.0   # Calorie counter
const CALORIES_PER_POUND: float = 3500.0

# Onready variables for UI elements
@onready var weight_label: Label = $UIBackground/VBoxContainer/WeightLabel
@onready var calories_label: Label = $UIBackground/VBoxContainer/CaloriesLabel
@onready var calorie_progress: ProgressBar = $UIBackground/VBoxContainer/CalorieProgress  # New progress bar

func _ready() -> void:
	setup_ui()
	setup_buttons()
	update_ui()

func setup_ui() -> void:
	# Get the UI background panel
	var ui_background = get_node_or_null("/root/MainScene/UIBackground")
	if ui_background:
		var panel_style = StyleBoxFlat.new()
		panel_style.bg_color = Color(0.1, 0.1, 0.1, 0.95)  # Dark background
		panel_style.corner_radius_top_left = 10
		panel_style.corner_radius_top_right = 10
		panel_style.corner_radius_bottom_left = 10
		panel_style.corner_radius_bottom_right = 10
		ui_background.add_theme_stylebox_override("panel", panel_style)
		ui_background.custom_minimum_size = Vector2(300, 200)  # Set minimum size
	
	# Set up weight label with style
	if weight_label:
		var label_style = StyleBoxFlat.new()
		label_style.bg_color = Color(0.15, 0.15, 0.15, 0.9)  # Slightly lighter background
		label_style.corner_radius_top_left = 5
		label_style.corner_radius_top_right = 5
		label_style.corner_radius_bottom_left = 5
		label_style.corner_radius_bottom_right = 5
		weight_label.add_theme_stylebox_override("normal", label_style)
		weight_label.add_theme_font_size_override("font_size", 36)
		weight_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		weight_label.text = "Weight: %0.1f lbs" % weight_lbs
	
	# Set up calories label with style
	if calories_label:
		var label_style = StyleBoxFlat.new()
		label_style.bg_color = Color(0.15, 0.15, 0.15, 0.9)
		label_style.corner_radius_top_left = 5
		label_style.corner_radius_top_right = 5
		label_style.corner_radius_bottom_left = 5
		label_style.corner_radius_bottom_right = 5
		calories_label.add_theme_stylebox_override("normal", label_style)
		calories_label.add_theme_font_size_override("font_size", 30)
		calories_label.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		calories_label.text = "Calories: %0.1f / %0.1f" % [weight_cals, CALORIES_PER_POUND]
	
	# Set up calorie progress bar
	if calorie_progress:
		calorie_progress.custom_minimum_size = Vector2(250, 20)  # Make it wider and taller
		calorie_progress.max_value = CALORIES_PER_POUND
		calorie_progress.value = weight_cals
		calorie_progress.show_percentage = false  # Hide percentage text
		
		# Setup progress bar background style
		var bg_style = StyleBoxFlat.new()
		bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.5)  # Dark background
		bg_style.corner_radius_top_left = 6
		bg_style.corner_radius_top_right = 6
		bg_style.corner_radius_bottom_left = 6
		bg_style.corner_radius_bottom_right = 6
		
		# Setup progress bar fill style
		var fg_style = StyleBoxFlat.new()
		fg_style.bg_color = Color(0.8, 0.3, 0.2, 1.0)  # Reddish-orange color for calories
		fg_style.corner_radius_top_left = 6
		fg_style.corner_radius_top_right = 6
		fg_style.corner_radius_bottom_left = 6
		fg_style.corner_radius_bottom_right = 6
		
		calorie_progress.add_theme_stylebox_override("background", bg_style)
		calorie_progress.add_theme_stylebox_override("fill", fg_style)

func theme_override_font_sizes(label: Label, size: int) -> void:
	# In Godot 4.x, we use theme overrides for font size
	label.add_theme_font_size_override("font_size", size)

func setup_buttons() -> void:
	# Food button data: calories and cooldown time
	var food_data = [
		{"calories": 200.0, "cooldown": .25},  # FoodButton1
		{"calories": 750.0, "cooldown": 1.0},  # FoodButton2
		{"calories": 1200.0, "cooldown": 3.0}   # FoodButton3
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
	# Check if button is on cooldown
	if button.get_meta("is_cooling_down", false):
		return
		
	# Get calories and cooldown from button metadata
	var calories = button.get_meta("calories", 0.0)
	var cooldown_time = button.get_meta("cooldown", 1.0)
	
	# Add calories and update weight if necessary
	weight_cals += calories
	emit_signal("calories_added", calories)
	
	while weight_cals >= CALORIES_PER_POUND:
		weight_lbs += 1.0
		weight_cals -= CALORIES_PER_POUND
		emit_signal("weight_changed", weight_lbs)
	
	# Update UI
	update_ui()
	
	# Play effects and start cooldown
	play_button_effects(button)
	start_button_cooldown(button, cooldown_time)

func start_button_cooldown(button: TextureButton, cooldown_time: float) -> void:
	# Set cooldown state
	button.set_meta("is_cooling_down", true)
	
	# Create progress bar if it doesn't exist
	var progress = button.get_node_or_null("CooldownProgress")
	if not progress:
		progress = ProgressBar.new()
		progress.name = "CooldownProgress"
		button.add_child(progress)
		
		# Style the progress bar
		progress.show_percentage = false
		progress.custom_minimum_size = Vector2(button.size.x, 8)  # Slightly taller
		progress.position = Vector2(0, button.size.y - 8)
		progress.max_value = cooldown_time
		
		# Setup progress bar style
		var bg_style = StyleBoxFlat.new()
		bg_style.bg_color = Color(0.2, 0.2, 0.2, 0.5)  # Dark background
		bg_style.corner_radius_top_left = 4
		bg_style.corner_radius_top_right = 4
		bg_style.corner_radius_bottom_left = 4
		bg_style.corner_radius_bottom_right = 4
		
		var fg_style = StyleBoxFlat.new()
		fg_style.bg_color = Color(0.2, 0.8, 0.2, 1.0)  # Green progress
		fg_style.corner_radius_top_left = 4
		fg_style.corner_radius_top_right = 4
		fg_style.corner_radius_bottom_left = 4
		fg_style.corner_radius_bottom_right = 4
		
		progress.add_theme_stylebox_override("background", bg_style)
		progress.add_theme_stylebox_override("fill", fg_style)
	
	# Animate cooldown
	var tween = create_tween()
	progress.value = cooldown_time
	tween.tween_property(progress, "value", 0, cooldown_time)
	
	# Wait for cooldown
	await get_tree().create_timer(cooldown_time).timeout
	
	# Reset cooldown state
	button.set_meta("is_cooling_down", false)
	progress.queue_free()

func play_button_effects(button: TextureButton) -> void:
	# Play sound effect
	var sound_player = button.get_node_or_null("ButtonSound")
	if sound_player:
		sound_player.play()
	
	# Play flash animation
	var flash_sprite = button.get_node_or_null("FlashSprite")
	if flash_sprite:
		# Make sure the sprite is visible by default
		flash_sprite.visible = true
		# Set modulate to fully visible
		flash_sprite.modulate.a = 1.0
		# Play the animation
		flash_sprite.play("flash")
		
		# Create a tween for the flash effect
		var tween = create_tween()
		# Wait a tiny bit before starting fade
		tween.tween_interval(0.1)
		# Fade out over 0.2 seconds
		tween.tween_property(flash_sprite, "modulate:a", 0.0, 0.2)
		# Reset alpha when done
		tween.tween_callback(func(): flash_sprite.modulate.a = 1.0)

func update_ui() -> void:
	# Update weight display
	if weight_label:
		weight_label.text = "Weight: %0.1f lbs" % weight_lbs
	
	# Update calories display
	if calories_label:
		calories_label.text = "Calories: %0.1f / %0.1f" % [weight_cals, CALORIES_PER_POUND]
	
	# Update calorie progress bar
	if calorie_progress:
		# Create a tween for smooth progress bar update
		var tween = create_tween()
		tween.tween_property(calorie_progress, "value", weight_cals, 0.2)
