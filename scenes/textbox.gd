extends CanvasLayer

@onready var textbox_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/endSymbol

enum state {
	READY,
	READING,
	FINISHED
}

var current_state = state.READY
var text_queue = []
var tween: Tween

func _ready() -> void:
	print("Estado inicial: state.READY")
	hideTextbox()

func _process(delta):
	match current_state:
		state.READY:
			if !text_queue.is_empty():
				displayText()
		state.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_characters = len(label.text)
				if tween and tween.is_valid():
					tween.kill()
					end_symbol.text = "↵"
				changeState(state.FINISHED)
		state.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				changeState(state.READY)
				hideTextbox()

func queueText(next_text):
	text_queue.push_back(next_text)

func hideTextbox():
	label.text =  ""
	end_symbol.text = ""
	textbox_container.hide()

func showTextbox():
	textbox_container.show()

func displayText():
	changeState(state.READING)
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.visible_characters = 0
	const CHAR_READ_RATE = 0.05
	showTextbox()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(label, "visible_characters", len(next_text), len(next_text) * CHAR_READ_RATE)
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	changeState(state.FINISHED)
	end_symbol.text = "↵"
	
func changeState(next_state):
	current_state = next_state
	match current_state:
		state.READY:
			print("Mudando estado para state.READY")
		state.READING:
			print("Mudando estado para state.READING")
		state.FINISHED:
			print("Mudando estado para state.FINISHED")
