class_name DeckAndHand
extends Node2D

signal card_activated(card: UsableCard)

@export var deck: Deck
@export var attack_card_scene: PackedScene = preload("res://scenes/cards/AttackCard.tscn")
@export var defense_card_scene: PackedScene = preload("res://scenes/cards/DefenseCard.tscn")

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


func remove_card(card: Node2D) -> void:
	hand.remove_by_entity(card)


func reset() -> void:
	hand.empty()


func _on_attack_button_pressed() -> void:
	var card = attack_card_scene.instantiate()
	deck.add(card)


func _on_defend_button_pressed() -> void:
	var card = defense_card_scene.instantiate()
	deck.add(card)


func _on_button3_pressed() -> void:
	if deck.get_cards().is_empty():
		return
		
	var random_card: CardWithID = deck.get_cards().pick_random()
	deck.remove(random_card.id)


func _on_hand_card_activated(card: UsableCard) -> void:
	card_activated.emit(card)
