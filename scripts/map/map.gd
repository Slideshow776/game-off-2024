class_name Map
extends Control

signal chosen(Encounter)

@onready var back_button: Button = %BackButton
@onready var ice_cream_isaac: Encounter = $IceCreamIsaac
@onready var muffin_max: Encounter = $MuffinMax


func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	ice_cream_isaac.pressed.connect(_on_encounter_pressed)
	muffin_max.pressed.connect(_on_encounter_pressed)


func _on_back_button_pressed() -> void:
	visible = false


func _on_encounter_pressed(encounter: Encounter) -> void:
	chosen.emit(encounter)
