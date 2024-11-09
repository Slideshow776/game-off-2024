class_name PlayableDeckUI
extends TextureButton

@onready var label: Label = %Label
var deck: PlayableDeck = PlayableDeck.new()


func draw() -> CardWithID:
	set_label_deck_size()
	return deck.deal_card()


func add_card(card_with_id: CardWithID):
	deck.put_card_on_top(card_with_id)
	set_label_deck_size()


func set_label_deck_size() -> void:
	if deck:
		label.set_text(str(deck.size()))
	else:
		label.set_text(str(0))


func reset() -> void:
	deck = PlayableDeck.new()
	set_label_deck_size()


func get_number_of_cards() -> int:
	return deck.cards.size()
