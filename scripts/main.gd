extends Node2D

@export var player_character: Character
@export var attack_card_data: CardData
@export var defend_card_data: CardData
@export var playable_card_scene: PackedScene
@export var debug_mode := true: 
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value

var enemy_character_state := 0

@onready var hand: Hand = %Hand
@onready var mana_orb: ManaOrb = %ManaOrb
@onready var game_controller: GameController = %GameController
@onready var end_turn_button: Button = %EndTurnButton
@onready var view_deck_button: TextureButton = %ViewDeckButton
@onready var enemy_character: Character = %EnemyCharacter
@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var deck_view_control: Control = %DeckViewControl
@onready var draw_pile: PlayableDeckUI = %DrawPile
@onready var discard_pile: PlayableDeckUI = %DiscardPile
@onready var deck: Deck = Deck.new()


func _ready() -> void:
	hand.card_activated.connect(_on_hand_card_activated)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	view_deck_button.pressed.connect(_on_view_deck_button_pressed)
	draw_pile.pressed.connect(_on_draw_pile_pressed)
	discard_pile.pressed.connect(_on_discard_pile_pressed)
	
	_generate_starting_deck()
	_restart_game()


func _process(delta: float) -> void:
	if !game_controller.is_running:
		return
	
	mana_orb.label.text = str(player_character.mana)
	
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
		mana_orb.fill_up_animation()
		end_turn_button.disabled = true
		player_character.start_turn()
		_deal_to_hand()
	
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
	elif event.is_action_pressed("mouse_click_back") && deck_view_control.visible:
		deck_view_control.visible = false


func _on_end_turn_pressed() -> void:
	if game_controller.current_state == GameController.GameState.PLAYER_TURN:
		end_turn_button.disabled = true
		game_controller.transition(GameController.GameState.ENEMY_TURN)
		enemy_character.start_turn()
		
		var cards: Array[PlayableCard] = hand.empty()
		for card in cards:
			card.visible = false
			discard_pile.add_card_on_top(deck.get_card(card.id))
			discard_pile.disabled = false


func _on_hand_card_activated(card: PlayableCard) -> void:
	var card_cost := card.get_cost()
	if card_cost <= player_character.mana:
		card.activate({
			"actor": player_character,
			"targets": [enemy_character],
			"cost": card_cost,
		})
		if player_character.mana > 0:
			mana_orb.spend_animation()
		else:
			mana_orb.empty_animation()
		
		hand.remove_by_entity(card)
		discard_pile.add_card_on_top(deck.get_card(card.id))
		discard_pile.disabled = false
	else:
		# TODO: indicate to the player that they're out of mana
		pass


func _restart_game() -> void:
	game_controller.current_state = GameController.GameState.PLAYER_TURN
	mana_orb.fill_up_animation()
	player_character.reset()
	enemy_character.reset()
	hand.empty()
		
	view_deck_button.disabled = deck.get_playable_deck().size() == 0	
	view_deck_button.deck = deck.get_playable_deck()
	view_deck_button.set_label_deck_size()
	
	draw_pile.deck = deck.get_playable_deck()
	draw_pile.disabled = false
	draw_pile.set_label_deck_size()
	draw_pile.deck.shuffle()
	
	discard_pile.deck = PlayableDeck.new()
	discard_pile.set_label_deck_size()
	discard_pile.disabled = true
	
	_deal_to_hand()


func _deal_to_hand():
	var tween := create_tween()
	for i in player_character.number_of_cards_to_be_dealt:
		_check_transfer_from_discard_to_draw_pile()
		tween.tween_callback(_draw_card_to_hand).set_delay(0.2)
	tween.tween_callback(func() -> void: end_turn_button.disabled = false)


func _on_view_deck_button_pressed() -> void:
	_toggle_deck_view(deck.get_cards(), DeckViewControl.Description.DECK)


func _on_draw_pile_pressed() -> void:
	_toggle_deck_view(draw_pile.deck.cards, DeckViewControl.Description.DRAW_PILE)


func _on_discard_pile_pressed() -> void:
	_toggle_deck_view(discard_pile.deck.cards, DeckViewControl.Description.DISCARD_PILE)


func _toggle_deck_view(deck: Array[CardWithID], type: DeckViewControl.Description) -> void:
	game_controller.toggle_pause_and_resume()
	deck_view_control.visible = !deck_view_control.visible
	deck_view_control.deck_view_window.display_card_list(deck)
	deck_view_control.set_description(type)


func _generate_starting_deck() -> void:
	for i in 19: deck.add_card(attack_card_data.duplicate())
	for i in 19: deck.add_card(defend_card_data.duplicate())


func _check_transfer_from_discard_to_draw_pile() -> void:
	if draw_pile.get_number_of_cards() < player_character.number_of_cards_to_be_dealt:
		var number_of_cards = discard_pile.get_number_of_cards()
		discard_pile.deck.shuffle()
		for i in number_of_cards:
			draw_pile.add_card_on_bottom(discard_pile.draw())
		draw_pile.disabled = false
		discard_pile.disabled = true
	discard_pile.set_label_deck_size()


func _draw_card_to_hand() -> void:	
	var card_with_id = draw_pile.draw()
	if card_with_id:
		draw_pile.set_label_deck_size()
		var playable_card = playable_card_scene.instantiate()
		add_child(playable_card)
		playable_card.visible = false
		playable_card.load_card_data(card_with_id.card)
		playable_card.id = card_with_id.id
		playable_card.global_position = hand.global_position
		remove_child(playable_card)
		hand.add_card(playable_card)
		
		if draw_pile.get_number_of_cards() == 0:
			draw_pile.disabled = true
