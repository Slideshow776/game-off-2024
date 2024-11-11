class_name PlayableDeck
extends Resource

var cards: Array[CardWithID] = []


func size() -> int:
	return cards.size()


func deal_card() -> CardWithID:
	return cards.pop_back()


func shuffle() -> void:
	cards.shuffle()


func peek_top() -> CardWithID:
	return cards.back()


func put_card_on_top(card: CardWithID) -> void:
	cards.push_back(card)


func put_card_on_bottom(card: CardWithID) -> void:
	cards.push_front(card)
