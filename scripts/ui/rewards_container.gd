class_name Rewards
extends Control

signal chosen(playable_cards: Array[PlayableCard])

var num_rewards := 1

@onready var reward_choose_a_card: RewardChooseACard = %RewardChooseACard
@onready var rewards_panel: TextureRect = %RewardsPanel
@onready var choose_a_card_button: Button = %ChooseACardButton
@onready var choose_a_secret_button: Button = %ChooseASecretButton


func _ready() -> void:
	choose_a_card_button.pressed.connect(_on_choose_a_card_button_pressed)
	choose_a_secret_button.pressed.connect(_on_choose_a_secret_button_pressed)
	reward_choose_a_card.chosen.connect(_on_chosen)


func activate(is_revealed_secret: bool) -> void:
	visible = true
	rewards_panel.visible = true
	choose_a_card_button.disabled = false
	choose_a_secret_button.disabled = false
	choose_a_secret_button.visible = is_revealed_secret
	
	if is_revealed_secret:
		num_rewards = 2


func _on_choose_a_card_button_pressed() -> void:
	choose_a_card_button.disabled = true	
	rewards_panel.visible = false
	reward_choose_a_card.visible = true
	
	reward_choose_a_card.activate(false)


func _on_choose_a_secret_button_pressed() -> void:
	choose_a_secret_button.disabled = true	
	rewards_panel.visible = false
	reward_choose_a_card.visible = true
	
	reward_choose_a_card.activate(true)


func _on_chosen(playable_card: PlayableCard):	
	chosen.emit(playable_card)
	rewards_panel.visible = true
