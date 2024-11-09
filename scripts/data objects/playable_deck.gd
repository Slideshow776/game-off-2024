class_name PlayableDeck
extends Resource

var cards: Array[CardWithID] = []


# draw a top card from the deck
func deal_card() -> CardWithID:
	return cards.pop_back()


func shuffle() -> void:
	cards.shuffle()


func peek_top() -> CardWithID:
	return cards.back()


func put_card_on_top(card: CardWithID) -> void:
	cards.push_back(card)
