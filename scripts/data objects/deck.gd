class_name Deck
extends Resource

var _card_collection : = {}
var _id_counter := 0


func add_card(card: CardData) -> void:
	var card_id = _generate_card_id(card)
	_card_collection[card_id] = CardWithID.new(card_id, card)


func remove_card_by_data(card_data: CardData) -> void:
	for card_id in _card_collection.keys():
		var card_with_id = _card_collection[card_id]
		if card_with_id.card.title == card_data.title:
			_card_collection.erase(card_id)
			break


func remove_card(card_id: int) -> void:
	_card_collection.erase(card_id)


func update_card(card_id: int, card: CardData) -> void:
	_card_collection[card_id] = card


func get_cards() -> Array[CardWithID]:
	var cards: Array[CardWithID] = []
	if !_card_collection.is_empty():
		for card in _card_collection.values():
			var duplicate_card_with_id: CardWithID = CardWithID.new(card.id, card.card.duplicate())
			cards.push_back(duplicate_card_with_id)
	return cards


func get_card(id: int) -> CardWithID:
	for card in _card_collection.values():
		if card.id == id:
			var duplicate_card_with_id: CardWithID = CardWithID.new(card.id, card.card.duplicate())
			return duplicate_card_with_id
	printerr("deck.gd => Error: couldn't find id: " + str(id))
	return null


func get_playable_deck() -> PlayableDeck:
	var playable_deck = PlayableDeck.new()
	playable_deck.cards = get_cards()
	return playable_deck


func shuffle() -> void:
	# Extract cards into an array for shuffling
	var card_list := _card_collection.values()
	card_list.shuffle()
	
	# Reconstruct _card_collection with the shuffled cards
	_card_collection.clear()
	for card_with_id in card_list:
		_card_collection[card_with_id.id] = card_with_id


func _generate_card_id(card: CardData) -> int:
	_id_counter += 1
	return _id_counter
