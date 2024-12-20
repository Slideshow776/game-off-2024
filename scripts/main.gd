extends Node2D

@export var player_character: Character
@export var enemy_character: Character

@export var gaslight_card_data: CardData
@export var overcompensate_card_data: CardData
@export var amnesia_card_data: CardData
@export var denial_draw_card_data: CardData
@export var more_mana_card_data: CardData
@export var exhaust_test_card_data: CardData
@export var appeal_to_nature_card_data: CardData
@export var strawman_card_data: CardData
@export var ad_hominem_card_data: CardData
@export var bandwagon_card_data: CardData
@export var false_lead_card_data: CardData

@export var turn_delay := 2.0

@export var playable_card_scene: PackedScene
@export var debug_mode := true: 
	set(value):
		if !is_node_ready():
			await ready
		debug_mode = value

var enemy_character_state := 0
var game_won := false
var rewards_received := 0
var ascension_level := 0
var ascension_modifier := 1.1

@onready var _original_music_volume := _get_music_bus_volume()
@onready var hand: Hand = %Hand
@onready var mana_orb: ManaOrb = %ManaOrb
@onready var game_controller: GameController = %GameController
@onready var end_turn_button: Button = %EndTurnButton
@onready var view_deck_button: PlayableDeckUI = %ViewDeckButton
@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var deck_view_control: DeckViewControl = %DeckViewControl
@onready var draw_pile: PlayableDeckUI = %DrawPile
@onready var discard_pile: PlayableDeckUI = %DiscardPile
@onready var deck: Deck = Deck.new()
@onready var game_over_color_rect: ColorRect = %GameOverColorRect
@onready var fade_in_color_rect: ColorRect = $CanvasLayer/FadeInColorRect
@onready var view_map_button: TextureButton = %ViewMapButton
@onready var map: Map = %Map
@onready var turn_announcer: TurnAnnouncer = %TurnAnnouncer
@onready var rewards: Rewards = %Rewards
@onready var secrecy_bar: SecrecyBar = %SecrecyBar
@onready var remove_choose_a_card: ChoiceRemoveCards = %RemoveChooseACard


func _ready() -> void:
	hand.card_activated.connect(_on_hand_card_activated)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	view_deck_button.pressed.connect(_on_view_deck_button_pressed)
	draw_pile.pressed.connect(_on_draw_pile_pressed)
	discard_pile.pressed.connect(_on_discard_pile_pressed)
	view_map_button.pressed.connect(_on_view_map_button_pressed)
	map.chosen.connect(_on_encounter_chosen_received)
	rewards.chosen.connect(_on_reward_card_chosen)
	remove_choose_a_card.chosen.connect(_on_remove_card_chosen)
	
	turn_announcer.total_duration = turn_delay
	_generate_starting_deck()
	turn_announcer.announce("Steal the secrets of sugar city!", turn_announcer.total_duration * 2.5)
	
	Input.set_custom_mouse_cursor(load("res://assets/images/ui/mouse_cursor.png"))
	map.return_to_map()
	map.back_button.visible = false


func _process(delta: float) -> void:
	if !game_controller.is_running:
		return


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		_restart_game()
	elif event.is_action_pressed("mouse_click_back") && deck_view_control.visible:
		deck_view_control._on_back_button_pressed()
	elif event.is_action_pressed("mouse_click_back") && map.visible && not game_won:
		map._on_back_button_pressed()
	
	if event.is_action_pressed("mouse_click") or event.is_action_pressed("mouse_click_back"):
		%ButtonSFX.play()


func _is_game_over() -> bool:
	if player_character.health <= 0:
		game_controller.transition(GameController.GameState.GAME_OVER)
	elif(enemy_character.health <= 0):
		game_controller.transition(GameController.GameState.GAME_WON)
		
	var game_over = game_controller.current_state == GameController.GameState.GAME_OVER
	
	#game_over_color_rect.visible =
	return game_over or enemy_character.health <= 0


func _start_player_turn() -> void:	
	if _is_game_over():
		return
	
	view_map_button.disabled = true
	view_deck_button.disabled = true
	draw_pile.disabled = true
	discard_pile.disabled = true
	turn_announcer.announce("Player Turn").finished.connect(func() -> void:		
		view_map_button.disabled = false
		view_deck_button.disabled = false
		draw_pile.disabled = false
		discard_pile.disabled = false
	)
	end_turn_button.disabled = true
	game_controller.transition(GameController.GameState.PLAYER_TURN)
	player_character.start_turn()
	mana_orb.fill_up_animation()
	mana_orb.label.text = str(player_character.mana)
	_deal_to_hand()


func _start_enemy_turn() -> void:
	game_controller.transition(GameController.GameState.ENEMY_TURN)
	enemy_character.start_turn()
	var tween: Tween = null
	
	match enemy_character_state: # ai logic
		0:
			enemy_character.add_defense(0 * ascension_modifier)
			%AttackActionSFX.play()
			tween = enemy_character.deal_damage_animation()
			player_character.take_damage(3 * ascension_modifier)
		1:
			enemy_character.add_defense(1 * ascension_modifier)
			%AttackActionSFX.play()
			tween = enemy_character.deal_damage_animation()
			player_character.take_damage(2 * ascension_modifier)
		2:
			enemy_character.add_defense(2 * ascension_modifier)
			%AttackActionSFX.play()
			tween = enemy_character.deal_damage_animation()
			player_character.take_damage(1 * ascension_modifier)
			
	enemy_character_state = posmod(enemy_character_state + 1, 3)
	if not _is_game_over():
		tween.tween_interval(turn_announcer.total_duration / 2)
		tween.finished.connect(_start_player_turn)
	else:
		tween.tween_interval(turn_announcer.total_duration / 2)
		tween.finished.connect(func() -> void:
			if _is_game_over():
				return
	
			turn_announcer.announce("Defeated!").finished.connect(func() -> void:
				map.visible = true
				map.back_button.visible = false
			)
		)


func _on_end_turn_pressed() -> void:
	if game_controller.current_state != GameController.GameState.PLAYER_TURN:
		return
		
	if _is_game_over():
		return
	
	end_turn_button.disabled = true
	view_map_button.disabled = true
	view_deck_button.disabled = true
	draw_pile.disabled = true
	discard_pile.disabled = true
	_empty_hand_to_discard_pile()
	turn_announcer.announce("Enemy Turn").finished.connect(_start_enemy_turn)


func _empty_hand_to_discard_pile() -> void:
	for playable_card in hand.empty():
		playable_card.visible = false
		if not playable_card.exhausted:
			discard_pile.add_card_on_top(deck.get_card(playable_card.id))
		discard_pile.disabled = false


func _on_hand_card_activated(playable_card: PlayableCard) -> void:
	if rewards.visible or _is_game_over():
		return
	
	var card_cost := playable_card.get_cost()
	if card_cost > player_character.mana:
		return
		
	playable_card.activate({
		"actor": player_character,
		"targets": [enemy_character],
		"cost": card_cost,
	})
	_check_if_card_won_the_game()
	
	for action in playable_card.actions:
		if action is DrawACardAction:
			%DrawCardSFX.play()
			_draw_a_card_to_hand(null, action.number_of_cards_to_draw)
		if action is ExhaustAction:
			playable_card.exhausted = true
			%CardBurnSFX.play()
		if action is ExhaustOtherRandomAction:
			var random_card = hand.cards.pick_random()
			(random_card as PlayableCard).exhausted = true
			hand.remove_by_entity(random_card)
			%CardBurnSFX.play()
		if action is RevealSecretAction:
			secrecy_bar.update(action.num_secrets_revealed)
		if action is HealAction:
			player_character.health += action.num_heal
	
	if playable_card.card.type == CardData.Type.ATTACK:
		%AttackActionSFX.play()
	if playable_card.card.type == CardData.Type.DEFENSE:
		%ShieldSFX.play()
	
	player_character.spend_mana(card_cost)
	mana_orb.label.text = str(player_character.mana)
	if player_character.mana > 0:
		mana_orb.spend_animation()
	else:
		mana_orb.empty_animation()
	
	hand.remove_by_entity(playable_card)
	if not playable_card.exhausted:
		discard_pile.add_card_on_top(deck.get_card(playable_card.id))
	discard_pile.disabled = discard_pile.deck.size() <= 0	


func _check_if_card_won_the_game() -> void:
	var tween := create_tween()
	tween.tween_interval(turn_announcer.total_duration)
	tween.finished.connect(func() -> void:
		if game_won:
			return
		
		if _is_game_over() and not game_won:
			rewards.activate(secrecy_bar.is_secret_revealed())
		
		if rewards.visible:
			_switch_music()
			game_won = true
	)


func _restart_game() -> void:
	game_won = false
	secrecy_bar.restart()
	rewards_received = 0
	map.back_button.visible = true
	player_character.soft_reset()
	player_character.heal_up_a_little()
	enemy_character.hard_reset()
	enemy_character_state = 0
	hand.empty()
	mana_orb.label.text = str(player_character.mana)
		
	view_deck_button.disabled = deck.get_playable_deck().size() == 0
	view_deck_button.deck = deck.get_playable_deck()
	view_deck_button.set_label_deck_size()
	
	deck.shuffle()
	draw_pile.deck = deck.get_playable_deck()
	draw_pile.disabled = false
	draw_pile.set_label_deck_size()
	draw_pile.deck.shuffle()
	
	discard_pile.deck = PlayableDeck.new()
	discard_pile.set_label_deck_size()
	discard_pile.disabled = true
		
	rewards.visible = false
	game_over_color_rect.visible = false
	
	var tween := create_tween()
	turn_announcer.announce("Battle start!").finished.connect(_start_player_turn)
	_fade_out()


func _deal_to_hand() -> void:
	%DealToHandSFX.play()
	var tween := create_tween()
	for i in player_character.number_of_cards_to_be_dealt:
		_draw_a_card_to_hand(tween, player_character.number_of_cards_to_be_dealt)
	tween.tween_callback(func() -> void: end_turn_button.disabled = false)


func _draw_a_card_to_hand(tween: Tween, cards_to_be_dealt: int) -> void:
	if tween == null:
		tween = create_tween()
		
	_check_transfer_from_discard_to_draw_pile(cards_to_be_dealt)
	tween.tween_callback(_draw_card_to_hand).set_delay(0.2)


func _on_view_deck_button_pressed() -> void:
	_toggle_deck_view(deck.get_cards(), DeckViewControl.Type.DECK)


func _on_draw_pile_pressed() -> void:
	_toggle_deck_view(draw_pile.deck.cards, DeckViewControl.Type.DRAW_PILE)


func _on_view_map_button_pressed() -> void:
	map.enable(_is_game_over())


func _on_discard_pile_pressed() -> void:
	_toggle_deck_view(discard_pile.deck.cards, DeckViewControl.Type.DISCARD_PILE)


func _toggle_deck_view(deck: Array[CardWithID], type: DeckViewControl.Type) -> void:
	game_controller.toggle_pause_and_resume()
	deck_view_control.visible = !deck_view_control.visible
	deck_view_control.deck_view_window.display_card_list(deck)
	(deck_view_control as DeckViewControl).set_type(type)
	(deck_view_control as DeckViewControl).play_audio(type, game_controller.is_running)


func _generate_starting_deck() -> void:
	for i in 5: deck.add_card(gaslight_card_data.duplicate())
	for i in 5: deck.add_card(overcompensate_card_data.duplicate())
	for i in 1: deck.add_card(false_lead_card_data.duplicate())
	
	#for i in 1: deck.add_card(ad_hominem_card_data.duplicate())
	#for i in 2: deck.add_card(amnesia_card_data.duplicate())
	#for i in 2: deck.add_card(denial_draw_card_data.duplicate())
	#for i in 2: deck.add_card(more_mana_card_data.duplicate())
	#for i in 2: deck.add_card(exhaust_test_card_data.duplicate())
	#for i in 2: deck.add_card(appeal_to_nature_card_data.duplicate())
	#for i in 2: deck.add_card(strawman_card_data.duplicate())
	#for i in 2: deck.add_card(bandwagon_card_data.duplicate())


func _check_transfer_from_discard_to_draw_pile(cards_to_be_dealt: int) -> void:
	if draw_pile.get_number_of_cards() < cards_to_be_dealt:
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


func _on_encounter_chosen_received(encounter: Encounter) -> void:
	enemy_character.load_data(encounter.character_data)
	secrecy_bar.initialize(enemy_character.character_data)
	map.visible = false
	map.back_button.disabled = false
	_switch_music()
	_restart_game()


func _on_remove_card_chosen(playable_card: PlayableCard) -> void:
	if playable_card:
		deck.remove_card_by_data(playable_card.card_data)
		view_deck_button.deck = deck.get_playable_deck()
		view_deck_button.set_label_deck_size()


func _on_reward_card_chosen(playable_card: PlayableCard) -> void:
	if playable_card:
		deck.add_card(playable_card.card_data)
		view_deck_button.deck = deck.get_playable_deck()
		view_deck_button.set_label_deck_size()
	
	rewards_received += 1
	
	if rewards_received < rewards.num_rewards:
		return
	
	rewards.visible = false
	
	map.return_to_map()
	if secrecy_bar.is_secret_revealed():
		map.disable(enemy_character)
	map.back_button.visible = false
	
	if map.is_all_encounters_defeated():
		map.enable_all_encounters()
		ascension_level += 1	
		remove_choose_a_card.activate(deck)
		map.ascension_label.visible = true
		map.ascension_label.set_text("Ascension: " + str(ascension_level))
		
		for encounter in map.get_all_encounters():
			encounter.character_data.max_health *= ascension_modifier
			encounter.character_data.num_secrets *= ascension_modifier
		
		ascension_modifier *= ascension_modifier


func _fade_out() -> void:
	fade_in_color_rect.visible = true
	fade_in_color_rect.modulate.a = 1.0
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(fade_in_color_rect, "modulate:a", 0.0, 0.5)


func _switch_music() -> void:
	var main_music = %MainMusic as AudioStreamPlayer
	var map_music = %MapMusic as AudioStreamPlayer
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	var duration: float = 0.5
	
	if main_music.playing:
		tween.set_ease(Tween.EASE_IN)
		tween.tween_method(_set_music_bus_volume, _original_music_volume, -80, duration)
		tween.tween_callback(map_music.play)
		tween.tween_callback(main_music.stop)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_method(_set_music_bus_volume, -80, _original_music_volume, duration)
	else:
		tween.set_ease(Tween.EASE_IN)
		tween.tween_method(_set_music_bus_volume, _original_music_volume, -80, duration)
		tween.tween_callback(main_music.play)
		tween.tween_callback(map_music.stop)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_method(_set_music_bus_volume, -80, _original_music_volume, duration)


func _set_music_bus_volume(volume_db: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), volume_db)


func _get_music_bus_volume() -> float:
	return AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))
