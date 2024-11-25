class_name RewardChooseACard
extends MarginContainer

signal chosen(playable_card: PlayableCard)

@export var possible_rewards: Array[CardData]
@export var test_card_data: CardData

var _reward_card_containers: Array[RewardCardContainer] = []
var _chosen_rewards: Array[CardData]


@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var reward_card_container_1: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer1
@onready var reward_card_container_2: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer2
@onready var reward_card_container_3: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer3
@onready var skip_button: Button = %SkipButton


func _ready() -> void:
	_chosen_rewards.clear()
	skip_button.pressed.connect(func() -> void: chosen.emit(null))
	
	_reward_card_containers.push_back(reward_card_container_1)
	_reward_card_containers.push_back(reward_card_container_2)
	_reward_card_containers.push_back(reward_card_container_3)
	
	for reward_card_container in _reward_card_containers:
		reward_card_container.playable_card.load_card_data(_get_reward())
		reward_card_container.chosen.connect(_on_chosen)


func _on_chosen(playable_card: PlayableCard):
	chosen.emit(playable_card)


func _get_reward() -> CardData:
	var reward: CardData = null
	while not reward:
		reward = possible_rewards.pick_random()
		if not _chosen_rewards.has(reward):
			_chosen_rewards.push_back(reward)
		else:
			reward = null
	
	return reward
