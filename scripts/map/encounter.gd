@tool
class_name Encounter
extends TextureButton

signal chosen(Encounter)

@export var character_data: CharacterData
@export var location: Texture2D
@export var connections: Array[Encounter]

@onready var label: Label = %Label


func _ready() -> void:
	label.set_text(character_data.name)
	pressed.connect(_on_pressed)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		label.set_text(character_data.name)


func get_center_position() -> Vector2:
	var position: Vector2 = global_position
	position.x += texture_normal.get_width() / 2
	position.y += texture_normal.get_height() / 2
	return position


func _on_pressed():
	pressed.emit(self)
