@tool
class_name Encounter
extends TextureButton

@export var description: String

@onready var label: Label = %Label


func _ready() -> void:
	label.set_text(description)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		label.set_text(description)
