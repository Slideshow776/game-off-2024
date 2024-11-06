class_name Deck
extends Resource

var card_collection : = {}
var id_counter := 0


func add(card: UsableCard) -> void:
	var card_id = _generate_card_id(card)
	card_collection[card_id] = CardWithID.new(card_id, card)
	id_counter += 1


func remove(card_id: int) -> void:
	card_collection.erase(card_id)


func update_card(card_id: int, card: UsableCard) -> void:
	card_collection[card_id] = card


func get_cards() -> Array[CardWithID]:
	var cards: Array[CardWithID] = []
	if !card_collection.is_empty():
		for card in card_collection.values():
			cards.push_back(card as CardWithID)	
	return cards


func _generate_card_id(card: UsableCard) -> int:
	return id_counter
