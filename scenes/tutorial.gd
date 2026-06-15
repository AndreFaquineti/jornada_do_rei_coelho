extends CanvasLayer

@onready var tutorial_panel = $TutorialContainer  # or whatever your root container is named

const SHOW_DURATION = 3.0  # seconds to stay visible
const SLIDE_SPEED = 0.5    # seconds for slide animation

var tween: Tween

func _ready():
	# Start hidden below the screen
	tutorial_panel.position.y = get_viewport().size.y
	show_tutorial()

func show_tutorial():
	if tween and tween.is_valid():
		tween.kill()
	
	# Slide up from bottom
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(tutorial_panel, "position:y", 500, SLIDE_SPEED)
	
	# Wait, then slide back down
	tween.tween_interval(SHOW_DURATION)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(tutorial_panel, "position:y", get_viewport().size.y, SLIDE_SPEED)
	
	tween.finished.connect(func(): hide())

func hide_tutorial():
	if tween and tween.is_valid():
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(tutorial_panel, "position:y", get_viewport().size.y, SLIDE_SPEED)
	tween.finished.connect(func(): hide())
