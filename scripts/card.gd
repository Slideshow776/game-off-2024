@tool
class_name Card
extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

enum Type { RED, BLUE }

@export var title: String = "TODO: Card Title"
@export var description: String = "TODO: Card Description"
@export_range(0, 20) var cost: int = 1
@export var image: Texture2D
@export var type: Type = Type.RED
	
var _original_scale: Vector2
var _original_position: Vector2

@onready var card_border_sprite: Sprite2D = %CardBorderSprite
@onready var image_sprite: Sprite2D = %ImageSprite
@onready var cost_label: Label = %CostLabel
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %descriptionLabel
@onready var area_2d: Area2D = %Area2D


func _ready() -> void:
	set_values(title, description, cost, type)
	
	area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)
	area_2d.mouse_exited.connect(_on_area_2d_mouse_exited)


func _process(delta: float) -> void:
	_update_graphics()


func set_values(
		temp_title:String = title,
		temp_desription: String = description,
		temp_cost: int = cost,
		temp_type: Type = type
	) -> void:
		
	cost = temp_cost	
	title = temp_title	
	description = temp_desription
	_set_type(temp_type)
	
	_original_scale = scale
	_original_position = position


func highlight() -> void:
	scale = _original_scale * 1.25
	position.y -= 125


func unhighlight() -> void:
	scale = _original_scale * 1.0
	position = _original_position


func _set_type(temp_type: Type) -> void:
	type = temp_type
	if card_border_sprite != null:
		card_border_sprite.modulate = _get_type(type)


func _get_type(type: Type) -> Color:
	match type:
		Type.RED:
			return Color.INDIAN_RED
		Type.BLUE:
			return Color.STEEL_BLUE
	return Color.WHITE


func _update_graphics() -> void:
	if cost_label != null and cost_label.text != str(cost):
		cost_label.text = str(cost)
		
	if title_label != null and title_label.text != title:
		title_label.text = title
		
	if description_label != null and description_label.text != description:
		description_label.text = description
		
	_set_type(type)
	
	if image != null:
		image_sprite.texture = image


func _on_area_2d_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_area_2d_mouse_exited() -> void:
	mouse_exited.emit(self)
