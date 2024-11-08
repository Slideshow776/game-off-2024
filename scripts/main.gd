extends Node2D

@export var player_character: Character
@export var debug_mode := true: 
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value
		%InflictOneButton.visible = debug_mode
		%InflictThreeButton.visible = debug_mode
		%DeckAndHand.visible = debug_mode

var enemy_character_state := 0

@onready var deck_and_hand: DeckAndHand = %DeckAndHand
@onready var mana_amount: Label = %ManaAmount
@onready var game_controller: GameController = %GameController
@onready var inflict_one_button: Button = %InflictOneButton
@onready var inflict_three_button: Button = %InflictThreeButton
@onready var end_turn_button: Button = %EndTurnButton
@onready var deck_texture_button: TextureButton = %DeckTextureButton
@onready var enemy_character: Character = %EnemyCharacter
@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var start_game_button: Button = %StartGameButton
@onready var playable_deck_ui: PlayableDeckUI = %PlayableDeckUi

@onready var deck: Deck = Deck.new()


func _ready() -> void:
	deck_and_hand.deck = deck
	
	inflict_one_button.pressed.connect(_on_inflict_one_button_pressed)
	inflict_three_button.pressed.connect(_on_inflict_three_button_pressed)
	deck_and_hand.card_activated.connect(_on_deck_and_hand_card_activated)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	deck_texture_button.pressed.connect(_on_deck_texture_button_pressed)
	start_game_button.pressed.connect(_on_start_game_button_pressed)
	playable_deck_ui.pressed.connect(_on_playable_deck_ui_pressed)


func _process(delta: float) -> void:
	if !game_controller.is_running:
		return
	
	mana_amount.text = "Mana: " + str(player_character.mana)
	
	if player_character.health <= 0:
		game_controller.transition(GameController.GameState.GAME_OVER)
	elif(enemy_character.health <= 0):
		game_controller.transition(GameController.GameState.GAME_WON)
	
	if game_controller.current_state == GameController.GameState.ENEMY_TURN:
		match enemy_character_state: # ai logic
			0:
				enemy_character.add_defense(0)
				player_character.take_damage(3)
			1:
				enemy_character.add_defense(1)
				player_character.take_damage(2)
			2:
				enemy_character.add_defense(2)
				player_character.take_damage(1)
				
		enemy_character_state = posmod(enemy_character_state + 1, 3)
		game_controller.transition(GameController.GameState.PLAYER_TURN)
		end_turn_button.disabled = false
		player_character.start_turn()
	
	if game_controller.current_state == GameController.GameState.GAME_WON:
		%GameWonColorRect.visible = true
	else:
		%GameWonColorRect.visible = false
	
	if game_controller.current_state == GameController.GameState.GAME_OVER:
		%GameOverColorRect.visible = true
	else:
		%GameOverColorRect.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart_game()


func _on_end_turn_pressed() -> void:
	if game_controller.current_state == GameController.GameState.PLAYER_TURN:
		end_turn_button.disabled = true
		game_controller.transition(GameController.GameState.ENEMY_TURN)
		enemy_character.start_turn()


func _on_deck_and_hand_card_activated(card: UsableCard) -> void:
	var card_cost := card.get_cost()
	if card_cost <= player_character.mana:
		card.activate({
			"caster": player_character,
			"targets": [$GameScreen/EnemyCharacter],
		})
		deck_and_hand.remove_card(card)
		card.queue_free()
	else:
		# TODO: indicate to the player that they're out of mana
		pass


func _inflict_damage_to_player(amount: int):
	player_character.take_damage(amount)


func _on_inflict_one_button_pressed() -> void:
	_inflict_damage_to_player(1)


func _on_inflict_three_button_pressed() -> void:
	_inflict_damage_to_player(3)


func _restart_game() -> void:
	playable_deck_ui.visible = true
	game_controller.current_state = GameController.GameState.PLAYER_TURN
	player_character.reset()
	enemy_character.reset()
	deck_and_hand.reset()
	playable_deck_ui.deck = deck.get_playable_deck()


func _on_deck_texture_button_pressed() -> void:
	game_controller.toggle_pause_and_resume()
	deck_view_window.visible = !deck_view_window.visible
	# this is a temporary test
	deck_view_window.display_card_list(deck.get_cards())


func _on_start_game_button_pressed() -> void:
	_restart_game()


func _on_playable_deck_ui_pressed() -> void:
	var card_with_id = playable_deck_ui.draw()
	
	if card_with_id:
		deck_and_hand.add_card(card_with_id)
