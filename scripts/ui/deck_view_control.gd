class_name DeckViewControl
extends Control

enum Description {
	DRAW_PILE,
	DISCARD_PILE,
	DECK,
}

@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var back_button: Button = %BackButton
@onready var label: Label = %Label


func _ready() -> void:
	back_button.pressed.connect(func() -> void:
		visible = !visible
	)

func set_description(type: Description) -> void:
	match type:
		Description.DRAW_PILE:
			label.set_text("Cards are drawn from here at the start of each turn.")
		Description.DISCARD_PILE:
			label.set_text("Cards shuffled into your empty draw pile.")
		Description.DECK:
			label.set_text("Cards you start with, each encounter.")
