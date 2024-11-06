@tool
class_name Character
extends Node2D

@export var max_health := 5
@export var start_mana := 3
@export var base_defense := 0
@export var current_mana_cap := 3

var health := 5
var mana := 5
var defense := 0


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	update_health_bar()
	update_defense_icon()


func set_health_values(new_health: int, new_max_health: int) -> void:
	max_health = new_max_health
	health = new_health


func start_turn() -> void:
	defense = 0
	mana = current_mana_cap


func update_health_bar() -> void:
	if ($HealthBar as ProgressBar).max_value != max_health:
		($HealthBar as ProgressBar).max_value = max_health
	if ($HealthBar as ProgressBar).value != health:
		($HealthBar as ProgressBar).value = health


func update_defense_icon() -> void:
	$"Defense".visible = defense > 0
	$"Defense/Label".text = str(defense)


func spend_mana(amount: int) -> void:
	mana -= amount


func take_damage(amount: int) -> void:
	var damage = max(amount - defense, 0)
	health -= damage


func add_defense(amount: int) -> void:
	defense += amount


func reset() -> void:
	health = max_health
	mana = start_mana
	defense = base_defense
