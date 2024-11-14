@tool
class_name Character
extends Node2D

#@export var texture2D: Texture2D
#@export var max_health := 5
#@export var start_mana := 3
#@export var base_defense := 0
#@export var current_mana_cap := 3
@export var character_data: CharacterData

var health := 5
var mana := 5
var defense := 0
var number_of_cards_to_be_dealt := 5

@onready var defense_icon: Sprite2D = %DefenseIcon
@onready var health_bar: ProgressBar = %HealthBar
@onready var label: Label = %Label
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var pivot: Node2D = %Pivot


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	sprite_2d.offset.y = pivot.position.y - (sprite_2d.position.y + sprite_2d.texture.get_height() / 2) * 0.95
	update_health_bar()
	update_defense_icon()
	sprite_2d.texture = character_data.texture


func set_health_values(new_health: int, new_max_health: int) -> void:
	character_data.max_health = new_max_health
	health = new_health


func start_turn() -> void:
	defense = 0
	mana = character_data.current_mana_cap


func update_health_bar() -> void:
	if health_bar == null:
		print("Character.gd => Error: health bar is null")
		return
		
	if health_bar.max_value != character_data.max_health:
		health_bar.max_value = character_data.max_health
	if health_bar.value != health:
		health_bar.value = health


func update_defense_icon() -> void:
	if defense_icon == null:
		print("Character.gd => Error: defense icon is null")
		return
		
	defense_icon.visible = defense > 0
	label.text = str(defense)


func spend_mana(amount: int) -> void:
	mana -= amount


func deal_damage_animation() -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(sprite_2d, "rotation", 0.1, 0.2)
	tween.tween_property(sprite_2d, "scale", Vector2(1.2, 0.8), 0.2)
	
	tween.set_parallel(false)
	tween.tween_property(sprite_2d, "rotation", 0.0, 0.2)
	tween.tween_property(sprite_2d, "scale", Vector2(1.0, 1.0), 0.2)


func take_damage(amount: int) -> void:
	var damage = max(amount - defense, 0)
	health -= damage
	update_health_bar()
	
	if damage > 0:
		var tween := create_tween()
		tween.tween_property(sprite_2d, "modulate", Color(1.0, 0.8, 0.8, 1.0), 0.1)
		tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.1)
		
		var tween1 := create_tween()
		tween1.tween_property(sprite_2d, "rotation", 0.05, 0.1)
		tween1.tween_property(sprite_2d, "rotation", -0.05, 0.2)
		tween1.tween_property(sprite_2d, "rotation", 0.0, 0.1)


func add_defense(amount: int) -> void:
	defense += amount
	update_defense_icon()


func reset() -> void:
	health = character_data.max_health
	mana = character_data.start_mana
	defense = character_data.base_defense
	
	update_health_bar()
	update_defense_icon()
