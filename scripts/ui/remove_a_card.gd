class_name ChoiceRemoveCards
extends Control

signal chosen(playable_card: PlayableCard)

@export var test_card_data: CardData

var _card_containers: Array[RewardCardContainer] = []
var _chosen_card: CardData

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var remove_card_container_1: RewardCardContainer = %RewardCardContainer1
@onready var remove_card_container_2: RewardCardContainer = %RewardCardContainer2
@onready var remove_card_container_3: RewardCardContainer = %RewardCardContainer3
@onready var skip_button: Button = %SkipButton


func _ready() -> void:
	skip_button.pressed.connect(func() -> void: _on_chosen(null))
	
	_card_containers.push_back(remove_card_container_1)
	_card_containers.push_back(remove_card_container_2)
	_card_containers.push_back(remove_card_container_3)


func activate(deck: Deck) -> void:
	visible = true
	_chosen_card = null
	for card_container in _card_containers:
		var card_data := deck.get_playable_deck().get_random_card().card
		card_container.playable_card.load_card_data(card_data)
		card_container.chosen.connect(_on_chosen)


func _on_chosen(playable_card: PlayableCard):
	if playable_card:
		print("emitting: " + playable_card.card_data.title)
	else:
		print("emitting null")
		
	chosen.emit(playable_card)
	visible = false
