class_name TurnAnnouncer
extends Label

var total_duration := 2.0

var _tween: Tween
var _original_position: Vector2


func _ready() -> void:
	_original_position = position
	visible = true


func announce(announcement: String, duration: float = total_duration) -> Tween:
	set_text(announcement)
	
	# slide in animation
	var offset := 1000
	position = _original_position
	scale.y = 0.0
	position.x += offset
	
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_EXPO)
	_tween.set_ease(Tween.EASE_OUT)
	_tween.set_parallel(true)
	_tween.tween_property(self, "scale:y", 1.0, duration * 2 / 5)
	_tween.tween_property(self, "position:x", position.x - offset, duration / 3)
	
	# pause
	_tween.set_parallel(false)
	_tween.tween_interval(duration / 3)
	
	# slide out
	_tween.set_ease(Tween.EASE_IN)
	_tween.set_parallel(true)
	_tween.tween_property(self, "scale:y", 0.0, duration * 2 / 5)
	_tween.tween_property(self, "position:x", position.x - 2*offset, duration / 3)
	
	return _tween
