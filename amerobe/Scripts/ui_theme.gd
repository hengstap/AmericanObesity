extends Control  # Changed from Node to Control

# Constants for UI styling
const COLORS = {
	"background": Color(0.1, 0.1, 0.1, 0.95),
	"panel": Color(0.15, 0.15, 0.15, 0.9),
	"text_normal": Color(1.0, 1.0, 1.0, 1.0),
	"text_highlight": Color(1.0, 0.8, 0.2, 1.0),
	"progress_fg": Color(0.2, 0.8, 0.2, 1.0),
	"progress_bg": Color(0.2, 0.2, 0.2, 0.5)
}

func _ready() -> void:
	# Create theme
	var theme = Theme.new()
	
	# Set up styles
	setup_panel_style(theme)
	setup_label_style(theme)
	setup_button_style(theme)
	setup_progress_style(theme)
	
	# Apply theme to the UI root (this node)
	self.theme = theme
	
	# Make this node fill the viewport
	set_anchors_preset(Control.PRESET_FULL_RECT)

func setup_panel_style(theme: Theme) -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = COLORS.background
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 15
	style.content_margin_bottom = 15
	
	theme.set_stylebox("panel", "PanelContainer", style)

func setup_label_style(theme: Theme) -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = COLORS.panel
	style.corner_radius_top_left = 5
	style.corner_radius_top_right = 5
	style.corner_radius_bottom_left = 5
	style.corner_radius_bottom_right = 5
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	
	theme.set_stylebox("normal", "Label", style)
	theme.set_color("font_color", "Label", COLORS.text_normal)
	theme.set_font_size("font_size", "Label", 24)

func setup_button_style(theme: Theme) -> void:
	# Normal state
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = COLORS.panel
	normal_style.corner_radius_top_left = 8
	normal_style.corner_radius_top_right = 8
	normal_style.corner_radius_bottom_left = 8
	normal_style.corner_radius_bottom_right = 8
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2
	normal_style.border_color = COLORS.text_highlight
	
	# Hover state
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = COLORS.panel.lightened(0.2)
	
	# Pressed state
	var pressed_style = normal_style.duplicate()
	pressed_style.bg_color = COLORS.panel.darkened(0.2)
	
	theme.set_stylebox("normal", "Button", normal_style)
	theme.set_stylebox("hover", "Button", hover_style)
	theme.set_stylebox("pressed", "Button", pressed_style)

func setup_progress_style(theme: Theme) -> void:
	# Background
	var bg_style = StyleBoxFlat.new()
	bg_style.bg_color = COLORS.progress_bg
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_left = 4
	bg_style.corner_radius_bottom_right = 4
	
	# Fill
	var fg_style = StyleBoxFlat.new()
	fg_style.bg_color = COLORS.progress_fg
	fg_style.corner_radius_top_left = 4
	fg_style.corner_radius_top_right = 4
	fg_style.corner_radius_bottom_left = 4
	fg_style.corner_radius_bottom_right = 4
	
	theme.set_stylebox("background", "ProgressBar", bg_style)
	theme.set_stylebox("fill", "ProgressBar", fg_style)
