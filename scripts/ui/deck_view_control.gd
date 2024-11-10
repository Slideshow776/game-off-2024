extends Control

@onready var deck_view_window: DeckViewWindow = %DeckViewWindow
@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(func() -> void:
		visible = !visible
	)
