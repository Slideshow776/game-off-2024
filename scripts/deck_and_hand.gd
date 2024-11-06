extends Node2D

signal card_activated(card: UsableCard)

var attack_card_scene: PackedScene = preload("res://scenes/AttackCard.tscn")
var defense_card_scene: PackedScene = preload("res://scenes/DefenseCard.tscn")

@onready var button: Button = %Button
@onready var button_2: Button = %Button2
@onready var spawn_point: Node2D = %"spawn point"
@onready var hand: Hand = %Hand


func _ready() -> void:
	button.pressed.connect(_on_attack_button_pressed)
	button_2.pressed.connect(_on_defend_button_pressed)
	hand.card_activated.connect(_on_hand_card_activated)


func _on_attack_button_pressed() -> void:
	var card = attack_card_scene.instantiate()
	hand.add(card)


func _on_defend_button_pressed() -> void:
	var card = defense_card_scene.instantiate()
	hand.add(card)


func _on_hand_card_activated(card: UsableCard) -> void:
	card_activated.emit(card)
