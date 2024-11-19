extends Control

@onready var reward_choose_a_card: MarginContainer = %RewardChooseACard
@onready var rewards_panel: TextureRect = %RewardsPanel
@onready var choose_a_card_button: Button = %ChooseACardButton


func _ready() -> void:
	choose_a_card_button.pressed.connect(_on_choose_a_card_button_pressed)
	

func _on_choose_a_card_button_pressed() -> void:
	reward_choose_a_card.visible = true
	rewards_panel.visible = false
