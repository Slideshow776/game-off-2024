class_name PlayableDeckUI
extends TextureButton

@onready var label: Label = %Label
var deck: PlayableDeck


func draw() -> CardWithID:
	set_label_deck_size()
	return deck.deal_card()


func set_label_deck_size() -> void:
	if deck:
		label.set_text(str(deck.size()))
	else:
		label.set_text(str(0))
