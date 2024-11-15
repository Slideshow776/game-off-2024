@tool
class_name Encounter
extends TextureButton

signal chosen(Encounter)

@export var character_data: CharacterData
@export var location: Texture2D

@onready var label: Label = %Label


func _ready() -> void:
	label.set_text(character_data.name)
	pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		label.set_text(character_data.name)


func _on_pressed():
	pressed.emit(self)
