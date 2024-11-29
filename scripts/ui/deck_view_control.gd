class_name DeckViewControl
extends Control

enum Type {
	DRAW_PILE,
	DISCARD_PILE,
	DECK,
}

var current_type: Type

@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var back_button: Button = %BackButton
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)


func play_audio(type: Type, is_open: bool) -> void:
	if is_open: # open sounds
		match type:
			Type.DRAW_PILE:
				%draw_deck_open.play()
			Type.DISCARD_PILE:
				%discard_deck_open.play()
			Type.DECK:
				%draw_deck_open.play()
	else: # closing sounds
		match type:
			Type.DRAW_PILE:
				%draw_deck_close.play()
			Type.DISCARD_PILE:
				%draw_deck_close.play()
			Type.DECK:
				%draw_deck_close.play()


func set_type(type: Type) -> void:
	current_type = type
	_set_description(type)
	_set_title(type)


func _on_back_button_pressed() -> void:
	visible = !visible
	play_audio(current_type, visible)


func _set_title(type: Type) -> void:
	match type:
		Type.DRAW_PILE:
			title_label.set_text("Draw Pile")
		Type.DISCARD_PILE:
			title_label.set_text("Discard Pile")
		Type.DECK:
			title_label.set_text("The Deck")


func _set_description(type: Type) -> void:
	match type:
		Type.DRAW_PILE:
			description_label.set_text("Cards are drawn from here at the start of each turn.")
		Type.DISCARD_PILE:
			description_label.set_text("Cards shuffled into your empty draw pile.")
		Type.DECK:
			description_label.set_text("Cards you start with, each encounter.")
