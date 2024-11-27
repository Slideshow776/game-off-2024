@tool
class_name Card
extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

enum Colour { RED, BLUE, GREEN, PURPLE }

@export var card_data: CardData

var title: String = "TODO: Card Title"
var description: String = "TODO: Card Description"
var cost: int = 1
var image: Texture2D
var colour: Colour = Colour.RED
var type: CardData.Type = CardData.Type.ATTACK

var is_highlighted := false
var tween_unhighlight: Tween

var _original_scale: Vector2
var _original_position: Vector2

@onready var card_border_sprite: Sprite2D = %CardBorderSprite
@onready var image_sprite: Sprite2D = %ImageSprite
@onready var cost_label: Label = %CostLabel
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %descriptionLabel
@onready var type_label: Label = %TypeLabel
@onready var area_2d: Area2D = %Area2D
@onready var card_sprite: Sprite2D = %CardSprite


func _ready() -> void:
	area_2d.mouse_entered.connect(_on_area_2d_mouse_entered)
	area_2d.mouse_exited.connect(_on_area_2d_mouse_exited)


func _process(delta: float) -> void:
	_update_graphics()


func set_values(
		temp_title:String = title,
		temp_desription: String = description,
		temp_cost: int = cost,
		temp_type: CardData.Type = CardData.Type.ATTACK,
		temp_image: Texture2D = image
	) -> void:
		
	title = temp_title
	description = temp_desription
	cost = temp_cost
	_set_colour(temp_type)
	_set_type(temp_type)
	if temp_image:
		_set_image(temp_image)
	elif card_data:
		_set_image(card_data.image)
	
	_original_scale = scale
	_original_position = position


func highlight() -> void:
	if not is_highlighted:
		is_highlighted = true
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self, "scale", _original_scale * 1.25, 0.2)
		tween.tween_property(self, "position:y", _original_position.y - 135, 0.2)


func unhighlight() -> void:
	if is_highlighted:
		is_highlighted = false
		tween_unhighlight = create_tween()
		tween_unhighlight.set_parallel()
		tween_unhighlight.tween_property(self, "scale", _original_scale * 1.0, 0.5)
		tween_unhighlight.tween_property(self, "position:y", _original_position.y, 0.5)


func _set_colour(temp_type: CardData.Type) -> void:
	if card_border_sprite == null:
		return
	
	match temp_type:
		CardData.Type.ATTACK:
			card_border_sprite.modulate = _get_colour(Colour.RED)
		CardData.Type.DEFENSE:
			card_border_sprite.modulate = _get_colour(Colour.BLUE)
		CardData.Type.SKILL:
			card_border_sprite.modulate = _get_colour(Colour.GREEN)
		CardData.Type.SECRET:
			card_border_sprite.modulate = _get_colour(Colour.PURPLE)


func _get_colour(colour: Colour) -> Color:
	match colour:
		Colour.RED:
			return Color("#ff6b6b")
		Colour.BLUE:
			return Color("#5ac8fa")
		Colour.GREEN:
			return Color("#5dc89d")
		Colour.PURPLE:
			return Color("#aa8cee")
	return Color.WHITE


func _set_image(texture: Texture2D) -> void:
	image = texture
	image_sprite.set_texture(image)


func _set_type(card_data_type: CardData.Type) -> String:
	type = card_data_type
	match card_data_type:
		CardData.Type.ATTACK:
			return "Attack"
		CardData.Type.DEFENSE:
			return "Defense"
		CardData.Type.SKILL:
			return "Skill"
		_:
			return ""


func _update_graphics() -> void:
	if card_data:
		set_values(card_data.title, card_data.description, card_data.cost, card_data.type)
	
	if cost_label != null and cost_label.text != str(cost):
		cost_label.text = str(cost)
		
	if title_label != null and title_label.text != title:
		title_label.text = title
		
	if description_label != null and description_label.text != description:
		description_label.text = description
		
	if type_label != null and type_label.text != _set_type(type):
		type_label.text = _set_type(type)
		
	_set_colour(type)
	
	if image != null:
		image_sprite.set_texture(image)


func _on_area_2d_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_area_2d_mouse_exited() -> void:
	mouse_exited.emit(self)
