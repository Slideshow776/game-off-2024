class_name SecrecyBar
extends ProgressBar

@onready var label: Label = %Label

var _num_revealed_secrets := 0
var _character_name := ""


func initialize(name: String, num_secrets: int) -> void:
	_character_name = name
	label.set_text(_character_name + "'s Secret!")
	max_value = num_secrets
	value = max_value
	
	_start_animation()


func update(revealed_secrets: int) -> void:
	_num_revealed_secrets += revealed_secrets
	value = _num_revealed_secrets
	
	if _num_revealed_secrets == max_value:
		label.set_text(_character_name + "'s secret revealed!")


func restart() -> void:
	_num_revealed_secrets = 0
	update(0)
	_start_animation()


func is_secret_revealed() -> bool:
	return _num_revealed_secrets == max_value


func _start_animation() -> void:
	var total_duration := 0.8
	var scale_amount := 0.05
	var value_tween := create_tween()
	value_tween.set_trans(Tween.TRANS_BOUNCE)
	value_tween.tween_property(self, "value", 0, total_duration)
	var scale_tween := create_tween()
	scale_tween.set_trans(Tween.TRANS_BOUNCE)
	scale_tween.tween_property(self, "scale", Vector2(1 - scale_amount, 1 + scale_amount), total_duration / 3)
	scale_tween.tween_property(self, "scale", Vector2(1 + scale_amount, 1 - scale_amount), total_duration / 3)
	scale_tween.tween_property(self, "scale", Vector2.ONE, total_duration / 3)
