extends Node2D

@export var player_character: Character

var enemy_character_state := 0

@onready var deck_and_hand: Node2D = %DeckAndHand
@onready var mana_amount: Label = %ManaAmount
@onready var game_controller: GameController = %GameController


func _ready() -> void:
	deck_and_hand.card_activated.connect(_on_deck_and_hand_card_activated)


func _process(delta: float) -> void:
	mana_amount.text = "Mana: " + str(player_character.mana)
	
	if game_controller.current_state == GameController.GameState.ENEMY_TURN:
		# TODO: ai logic
		match enemy_character_state:
			0:
				pass
			1:
				pass
			3:
				pass
		enemy_character_state = posmod(enemy_character_state + 1, 3)


func _on_deck_and_hand_card_activated(card: UsableCard) -> void:
	card.activate({
		"caster": player_character,
		"targets": [$GameScreen/EnemyCharacter],
	})


func inflict_damage_to_player(amount: int):
	player_character.take_damage(amount)


func _on_inflict_one_button_pressed() -> void:
	inflict_damage_to_player(1)


func _on_inflict_three_button_pressed() -> void:
	inflict_damage_to_player(3)
