class_name PlayableCard
extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

var actions: Array[Action]
var id := -1
var card_data: CardData
var exhausted := false

@onready var card: Card = %Card


func _ready() -> void:
	card.mouse_entered.connect(_on_card_mouse_entered)
	card.mouse_exited.connect(_on_card_mouse_exited)


func load_card_data(card_data: CardData) -> void:
	self.card_data = card_data
	card.set_values(
		card_data.title,
		card_data.description,
		card_data.cost,
		card_data.type,
		card_data.image,
	)
	
	for script in card_data.actions:
		var action_script = RefCounted.new()
		action_script.set_script(script)
		actions.push_back(action_script)


func highlight() -> void:
	card.highlight()


func unhighlight() -> void:
	card.unhighlight()


func get_cost() -> int:
	return card.cost


func activate(game_state: Dictionary) -> void:
	for action in actions:
		action.activate(game_state)


func _on_card_mouse_entered(card: Card) -> void:
	mouse_entered.emit(self)


func _on_card_mouse_exited(card: Card) -> void:
	mouse_exited.emit(self)
