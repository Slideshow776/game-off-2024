class_name ManaOrb
extends Sprite2D

var _original_position: Vector2
var _fill_up_tween: Tween
var _spend_tween: Tween
var _empty_tween: Tween

@onready var label: Label = %Label
@onready var mana_orb: Sprite2D = $"."


func _ready() -> void:
	_original_position = position


func fill_up_animation() -> void:
	if _empty_tween:
		_empty_tween.kill()
		
	%ManaGlassSFX.play()
	
	_fill_up_tween = create_tween()
	_fill_up_tween.set_parallel(true)	
	_fill_up_tween.set_trans(Tween.TRANS_LINEAR)
	_fill_up_tween.tween_property(self, "rotation", 0, 0.2)
	_fill_up_tween.tween_property(self, "position", _original_position, 0.2)
	_fill_up_tween.set_trans(Tween.TRANS_BOUNCE)
	_fill_up_tween.set_ease(Tween.EASE_OUT)
	_fill_up_tween.tween_property(self, "modulate", Color(1, 1, 1), 0.5)
	
	_fill_up_tween.set_parallel(false)
	_fill_up_tween.set_trans(Tween.TRANS_BACK)
	_fill_up_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
	_fill_up_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)


func spend_animation() -> void:
	_spend_tween = create_tween()
	var duration := 0.15
	var amount := 0.15
	_spend_tween.tween_property(self, "rotation", -amount, duration)
	_spend_tween.tween_property(self, "rotation", amount, duration)
	_spend_tween.tween_property(self, "rotation", -amount, duration)
	_spend_tween.tween_property(self, "rotation", amount, duration)
	_spend_tween.tween_property(self, "rotation", 0, duration)

func empty_animation() -> void:
	_empty_tween = create_tween()
	_empty_tween.set_parallel()
	_empty_tween.set_trans(Tween.TRANS_EXPO)
	_empty_tween.set_ease(Tween.EASE_IN)
	_empty_tween.tween_property(self, "position:y", position.y + 12.5, 1.0)
	_empty_tween.tween_property(self, "rotation", 0.5, 1.0)
	_empty_tween.set_trans(Tween.TRANS_BOUNCE)
	_empty_tween.set_ease(Tween.EASE_OUT)
	_empty_tween.tween_property(self, "modulate", Color(0.6, 0.6, 0.6), 1.0)
