extends Node

# Scene paths
const SCENES = {
	"title": "res://scenes/title_screen.tscn",
	"main_game": "res://scenes/main.tscn",
	"evolution": "res://scenes/evolution.tscn",
	"kitchen_tier2": "res://scenes/tier_2.tscn"
}

# Game state
var current_weight: float = 150.0
var current_tier: int = 1
var unlocked_items = []

# Evolution thresholds
const EVOLUTION_WEIGHTS = {
	1: 175.0,  # First evolution at 250 lbs
	2: 250.0   # Second evolution at 500 lbs
}

func _ready() -> void:
	# Initialize game state
	load_game_state()

# Scene transition handling
func transition_to_scene(scene_name: String) -> void:
	# Save current game state before transition
	save_game_state()
	
	match scene_name:
		"title":
			get_tree().change_scene_to_file(SCENES.title_screen)
		"main_game":
			get_tree().change_scene_to_file(SCENES.main)
		"evolution":
			start_evolution_sequence()
		"tier_2":
			get_tree().change_scene_to_file(SCENES.tier_2)

# Evolution sequence
func start_evolution_sequence() -> void:
	# Save current state
	save_game_state()
	
	# Load evolution scene
	get_tree().change_scene_to_file(SCENES.evolution)
	
	# The evolution scene will handle the animation and call
	# finish_evolution() when complete

func finish_evolution() -> void:
	current_tier += 1
	unlock_new_items()
	
	# Transition to next kitchen tier
	transition_to_scene("kitchen_tier2")

# Item management
func unlock_new_items() -> void:
	match current_tier:
		2:
			unlocked_items.append_array([
				"double_burger",
				"cheezy_fries",
				"big_gulp"
			])

# Save/Load functions
func save_game_state() -> void:
	var save_data = {
		"weight": current_weight,
		"tier": current_tier,
		"unlocked_items": unlocked_items
	}
	
	var save_file = FileAccess.open("user://progress.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_data))

func load_game_state() -> void:
	if FileAccess.file_exists("user://progress.save"):
		var save_file = FileAccess.open("user://progress.save", FileAccess.READ)
		var json_string = save_file.get_as_text()
		var save_data = JSON.parse_string(json_string)
		
		if save_data:
			current_weight = save_data.weight
			current_tier = save_data.tier
			unlocked_items = save_data.unlocked_items

# Weight tracking
func update_weight(new_weight: float) -> void:
	current_weight = new_weight
	
	# Check for evolution threshold
	if current_tier < 3:  # Max tier is 2 for now
		var next_threshold = EVOLUTION_WEIGHTS[current_tier]
		if current_weight >= next_threshold:
			transition_to_scene("evolution")
