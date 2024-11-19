extends MarginContainer

@export var card_data: Array[CardData]

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var reward_card_container_1: MarginContainer = $VBoxContainer/HBoxContainer/RewardCardContainer1
@onready var reward_card_container_2: MarginContainer = $VBoxContainer/HBoxContainer/RewardCardContainer2
@onready var reward_card_container_3: MarginContainer = $VBoxContainer/HBoxContainer/RewardCardContainer3


func _ready() -> void:
	reward_card_container_1.playable_card.load_card_data(card_data.pick_random())
	reward_card_container_2.playable_card.load_card_data(card_data.pick_random())
	reward_card_container_3.playable_card.load_card_data(card_data.pick_random())
