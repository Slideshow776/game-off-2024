@tool
class_name Character
extends Node2D

@export var max_health := 10
@export var health := 10
@export var mana := 10
@export var defense: int = 0


func _process(delta: float) -> void:
	update_health_bar()
	update_defense_icon()


func set_health_values(new_health: int, new_max_health: int):
	max_health = new_max_health
	health = new_health


func update_health_bar():
	if ($HealthBar as ProgressBar).max_value != max_health:
		($HealthBar as ProgressBar).max_value = max_health
	if ($HealthBar as ProgressBar).value != health:
		($HealthBar as ProgressBar).value = health


func update_defense_icon():
	$"Defense".visible = defense > 0
	$"Defense/Label".text = str(defense)


func spend_mana(amount: int):
	mana -= amount


func take_damage(amount: int):
	var damage = max(amount - defense, 0)
	health -= damage


func add_defense(amount: int):
	defense += amount
