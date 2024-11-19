class_name Rewards
extends Control

signal chosen(playable_card: PlayableCard)

@onready var reward_choose_a_card: RewardChooseACard = %RewardChooseACard
@onready var rewards_panel: TextureRect = %RewardsPanel
@onready var choose_a_card_button: Button = %ChooseACardButton


func _ready() -> void:
	choose_a_card_button.pressed.connect(_on_choose_a_card_button_pressed)
	reward_choose_a_card.chosen.connect(_on_chosen)
	

func _on_choose_a_card_button_pressed() -> void:
	reward_choose_a_card.visible = true
	rewards_panel.visible = false


func _on_chosen(playable_card: PlayableCard):
	chosen.emit(playable_card)
