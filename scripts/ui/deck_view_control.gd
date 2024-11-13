class_name DeckViewControl
extends Control

enum Description {
	DRAW_PILE,
	DISCARD_PILE,
	DECK,
}

@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var back_button: Button = %BackButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel


func _ready() -> void:
	back_button.pressed.connect(func() -> void:
		visible = !visible
	)


func set_type(type: Description) -> void:
	_set_description(type)
	_set_title(type)


func _set_title(type: Description) -> void:
	match type:
		Description.DRAW_PILE:
			title_label.set_text("Draw Pile")
		Description.DISCARD_PILE:
			title_label.set_text("Discard Pile")
		Description.DECK:
			title_label.set_text("The Deck")

func _set_description(type: Description) -> void:
	match type:
		Description.DRAW_PILE:
			description_label.set_text("Cards are drawn from here at the start of each turn.")
		Description.DISCARD_PILE:
			description_label.set_text("Cards shuffled into your empty draw pile.")
		Description.DECK:
			description_label.set_text("Cards you start with, each encounter.")
