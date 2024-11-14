class_name Map
extends Control

@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)


func _on_back_button_pressed() -> void:	
	visible = false
