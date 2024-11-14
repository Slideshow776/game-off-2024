@tool
class_name Encounter
extends TextureButton

@export var character_data: CharacterData

@onready var label: Label = %Label


func _ready() -> void:
	label.set_text(character_data.name)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		label.set_text(character_data.name)
