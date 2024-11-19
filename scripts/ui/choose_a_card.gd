class_name RewardChooseACard
extends MarginContainer

signal chosen(playable_card: PlayableCard)

@export var card_data: Array[CardData]
@export var test_card_data: CardData

var rewards: Array[RewardCardContainer] = []

@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var reward_card_container_1: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer1
@onready var reward_card_container_2: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer2
@onready var reward_card_container_3: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer3


func _ready() -> void:
	rewards.push_back(reward_card_container_1)
	rewards.push_back(reward_card_container_2)
	rewards.push_back(reward_card_container_3)
	
	for reward in rewards:
		reward.playable_card.load_card_data(test_card_data)
		#reward.playable_card.load_card_data(card_data.pick_random())
		reward.chosen.connect(_on_chosen)


func _on_chosen(playable_card: PlayableCard):
	chosen.emit(playable_card)
