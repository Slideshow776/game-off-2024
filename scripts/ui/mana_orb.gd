class_name ManaOrb
extends Sprite2D

var _original_position: Vector2

@onready var label: Label = %Label
@onready var mana_orb: Sprite2D = $"."


func _ready() -> void:
	_original_position = position


func fill_up_animation() -> void:
	var tween := create_tween()
	tween.set_parallel(true)	
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "rotation", 0, 0.2)
	tween.tween_property(self, "position", _original_position, 0.2)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.5)
	
	tween.set_parallel(false)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)


func spend_animation() -> void:
	var tween := create_tween()
	var duration := 0.15
	var amount := 0.15
	tween.tween_property(self, "rotation", -amount, duration)
	tween.tween_property(self, "rotation", amount, duration)
	tween.tween_property(self, "rotation", -amount, duration)
	tween.tween_property(self, "rotation", amount, duration)
	tween.tween_property(self, "rotation", 0, duration)


func empty_animation() -> void:
	var tween := create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", position.y + 12.5, 1.0)
	tween.tween_property(self, "rotation", 0.5, 1.0)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(0.6, 0.6, 0.6), 1.0)
