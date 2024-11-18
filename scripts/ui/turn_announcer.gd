class_name TurnAnnouncer
extends Label

var total_duration := 2.0
var _original_position: Vector2


func _ready() -> void:
	_original_position = position


func announce(announcement: String) -> Tween:
	set_text(announcement)
	
	# slide in animation
	var offset := 1000
	position = _original_position
	scale.y = 0.0
	position.x += offset
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "scale:y", 1.0, total_duration * 2 / 5)
	tween.tween_property(self, "position:x", position.x - offset, total_duration / 3)
	
	# pause
	tween.set_parallel(false)
	tween.tween_interval(total_duration / 3)
	
	# slide out
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	tween.tween_property(self, "scale:y", 0.0, total_duration * 2 / 5)
	tween.tween_property(self, "position:x", position.x - 2*offset, total_duration / 3)
	
	return tween
