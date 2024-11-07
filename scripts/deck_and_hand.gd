class_name DeckAndHand
extends Node2D

signal card_activated(card: UsableCard)

@export var deck: Deck
@export var debug_mode := true:
	set(value):
		if !is_node_ready():
			await ready
		%Button.visible = debug_mode
		%Button2.visible = debug_mode
		%Button3.visible = debug_mode

@export var attack_card_data: CardData = preload("res://card_data/attack_card.tres")
@export var defense_card_data: CardData = preload("res://card_data/defend_card.tres")

@onready var button: Button = %Button
@onready var button_2: Button = %Button2
@onready var button_3: Button = %Button3
@onready var spawn_point: Node2D = %"spawn point"
@onready var hand: Hand = %Hand


func _ready() -> void:
	button.pressed.connect(_on_attack_button_pressed)
	button_2.pressed.connect(_on_defend_button_pressed)
	button_3.pressed.connect(_on_button3_pressed)
	hand.card_activated.connect(_on_hand_card_activated)


func add_card(card_with_id: CardWithID) -> void:
	hand.add_card(card_with_id.card)


func remove_card(card: Node2D) -> void:
	hand.remove_by_entity(card)


func reset() -> void:
	hand.empty()


func _on_attack_button_pressed() -> void:
	deck.add_card(attack_card_data.duplicate())


func _on_defend_button_pressed() -> void:
	deck.add_card(defense_card_data.duplicate())


func _on_button3_pressed() -> void:
	if deck.get_cards().is_empty():
		return
		
	var random_card: CardWithID = deck.get_cards().pick_random()
	deck.remove_card(random_card.id)


func _on_hand_card_activated(card: UsableCard) -> void:
	card_activated.emit(card)
