extends Node2D  # or whatever your new scene uses

var avancar = false
var mudar_cena = true
@onready var instrucao = $TextboxContainer/MarginContainer/instrucao

func _ready():
	# The name "Textbox" is the autoload name you set
	instrucao.text = "Aperte Enter para avançar"
	Textbox.queueText("Era uma vez no distante reino das cenouras um nobre rei...\n...\n...\n coelho(???).")
	Textbox.queueText("Bom, sim, o rei das cenouras era um coelho. E ele fora um soberano nobre e amado por seu povo.")
	Textbox.queueText("Mas um dia, o terrível Vincent invadiu a capital.\nMontado no seu Cenoróide™, ele derrotou a guarda do rei facilmente.")
	Textbox.queueText("O usurpador, expulsou o coitado do rei coelho e o proibiu de voltar ao seu reino.\nO povo cenoura o temia e, relutantes, concordaram em lutar contra a volta do rei coelho.")
	Textbox.queueText("Agora o rei sem coroa e sozinho(?) deve recuperar seu trono e libertar o reino das patinhas tiranas de Vincent...")
	
func _process(delta):
	if Textbox.text_queue.is_empty():
		instrucao.text = "Aperte Enter para retomar o reino."
	if mudar_cena and Textbox.current_state == Textbox.state.READY and Textbox.text_queue.is_empty():
		var mudar_cena = false
		get_tree().change_scene_to_file("res://scenes/world.tscn")
