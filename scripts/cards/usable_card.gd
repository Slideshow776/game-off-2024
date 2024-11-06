class_name UsableCard
extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

@export var action: Node2D

@onready var card: Card = %Card
@onready var attack_action: Node2D = %AttackAction
@onready var defense_action: Node2D = %DefenseAction


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
	if attack_action != null:
		attack_action.activate(game_state)
	if defense_action != null:
		defense_action.activate(game_state)
