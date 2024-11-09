extends Node2D

@export var player_character: Character
@export var attack_card_data: CardData
@export var defend_card_data: CardData
@export var debug_mode := true: 
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value

var enemy_character_state := 0

@onready var hand: Hand = %Hand
@onready var mana_amount: Label = %ManaAmount
@onready var game_controller: GameController = %GameController
@onready var end_turn_button: Button = %EndTurnButton
@onready var deck_texture_button: TextureButton = %DeckTextureButton
@onready var enemy_character: Character = %EnemyCharacter
@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var draw_pile: PlayableDeckUI = %DrawPile
@onready var discard_pile: PlayableDeckUI = %DiscardPile
@onready var deck: Deck = Deck.new()


func _ready() -> void:
	hand.card_activated.connect(_on_hand_card_activated)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	deck_texture_button.pressed.connect(_on_deck_texture_button_pressed)
	draw_pile.pressed.connect(_on_draw_pile_pressed)
	
	for i in 10:
		deck.add_card(attack_card_data.duplicate())
		deck.add_card(defend_card_data.duplicate())		
	
	_restart_game()


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


func _on_hand_card_activated(card: PlayableCard) -> void:
	var card_cost := card.get_cost()
	if card_cost <= player_character.mana:
		card.activate({
			"actor": player_character,
			"targets": [enemy_character],
			"cost": card_cost
		})
		hand.remove_by_entity(card)
		card.queue_free()
	else:
		# TODO: indicate to the player that they're out of mana
		pass


func _restart_game() -> void:
	draw_pile.visible = true
	game_controller.current_state = GameController.GameState.PLAYER_TURN
	player_character.reset()
	enemy_character.reset()
	hand.empty()
	
	draw_pile.deck = deck.get_playable_deck()
	draw_pile.set_label_deck_size()
	discard_pile.set_label_deck_size()


func _on_deck_texture_button_pressed() -> void:
	game_controller.toggle_pause_and_resume()
	deck_view_window.visible = !deck_view_window.visible
	# this is a temporary test
	deck_view_window.display_card_list(deck.get_cards())


func _on_draw_pile_pressed() -> void:
	var card_with_id = draw_pile.draw()	
	if card_with_id:
		draw_pile.set_label_deck_size()
		hand.add_card(card_with_id.card)
