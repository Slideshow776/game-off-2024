class_name UsableCard
extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

var actions: Array[RefCounted]

@onready var card: Card = %Card
@onready var attack_action: Node2D = %AttackAction
@onready var defense_action: Node2D = %DefenseAction
@onready var card_image_texture: Texture2D


func load_card_data(card_data: CardData) -> void:
	card.set_values(card_data.title, card_data.description, card_data.cost)
	card.set_image(card_data.image)
	card.set_type(card_data.type)
	for script in card_data.actions:
		var action_script = RefCounted.new()
		action_script.set_script(script)
		actions.push_back(action_script)


func _ready() -> void:
	card.mouse_entered.connect(_on_card_mouse_entered)
	card.mouse_exited.connect(_on_card_mouse_exited)


func highlight() -> void:
	card.highlight()


func unhighlight() -> void:
	card.unhighlight()


func get_cost() -> int:
	return card.cost


func _on_card_mouse_entered(card: Card) -> void:
	mouse_entered.emit(self)


func _on_card_mouse_exited(card: Card) -> void:
	mouse_exited.emit(self)


func activate(game_state: Dictionary) -> void:
	for action in actions:
		action.activate(game_state)
