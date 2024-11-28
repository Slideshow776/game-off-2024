class_name RewardChooseACard
extends MarginContainer

signal chosen(playable_card: PlayableCard)

@export var normal_possible_rewards: Array[CardData]
@export var secret_possible_rewards: Array[CardData]
@export var test_card_data: CardData

var _reward_card_containers: Array[RewardCardContainer] = []
var _chosen_rewards: Array[CardData]


@onready var h_box_container: HBoxContainer = %HBoxContainer
@onready var reward_card_container_1: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer1
@onready var reward_card_container_2: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer2
@onready var reward_card_container_3: RewardCardContainer = $VBoxContainer/HBoxContainer/RewardCardContainer3
@onready var skip_button: Button = %SkipButton


func _ready() -> void:
	skip_button.pressed.connect(func() -> void: _on_chosen(null))
	
	_reward_card_containers.push_back(reward_card_container_1)
	_reward_card_containers.push_back(reward_card_container_2)
	_reward_card_containers.push_back(reward_card_container_3)	


func activate(is_revealed_secret: bool) -> void:
	visible = true
	_chosen_rewards.clear()
	for reward_card_container in _reward_card_containers:
		var reward := _get_reward(is_revealed_secret)
		reward_card_container.playable_card.load_card_data(reward)
		reward_card_container.chosen.connect(_on_chosen)


func _on_chosen(playable_card: PlayableCard):
	chosen.emit(playable_card)
	visible = false


func _get_reward(is_revealed_secret: bool) -> CardData:
	var reward: CardData = null
	while not reward:
		# select type of reward
		if is_revealed_secret:
			reward = secret_possible_rewards.pick_random()
		else:
			reward = normal_possible_rewards.pick_random()
			
		# ensure no duplicates
		if not _chosen_rewards.has(reward):
			_chosen_rewards.push_back(reward)
		else:
			reward = null
	
	return reward
