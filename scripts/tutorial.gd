extends Control

@export var display_time: float = 3.0
@export var slide_distance: float = 100.0
@export var animation_duration: float = 0.3

@onready var panel = $PanelContainer

var tween: Tween

func _ready():
	# Anchor to bottom center
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 1.0
	anchor_bottom = 1.0
	offset_left = -150
	offset_right = 150
	offset_top = -80
	offset_bottom = -20
	
	# Start hidden below screen
	panel.modulate.a = 0.0
	panel.position.y += slide_distance

func show_message(text: String):
	$PanelContainer/MarginContainer/Label.text = text
	
	# Kill existing tween if any
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# Slide in + fade in
	tween.parallel().tween_property(panel, "position:y", panel.position.y - slide_distance, animation_duration)
	tween.parallel().tween_property(panel, "modulate:a", 1.0, animation_duration)
	
	# Wait, then slide out + fade out
	tween.tween_interval(display_time)
	tween.parallel().tween_property(panel, "position:y", panel.position.y, animation_duration)
	tween.parallel().tween_property(panel, "modulate:a", 0.0, animation_duration)
	
	# Optional: free after animation
	tween.tween_callback(queue_free)
