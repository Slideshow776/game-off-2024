class_name PlayableDeck
extends Resource

var cards: Array[CardWithID] = []

# draw a top card from the deck
func draw_card() -> CardWithID:
	return cards.pop_back()


# shuffle the order of cards in the dec
func shuffle() -> void:
	cards.shuffle()


func peek_top() -> CardWithID:
	return cards.back()


func put_card_on_top(card: CardWithID) -> void:
	cards.push_back(card)
