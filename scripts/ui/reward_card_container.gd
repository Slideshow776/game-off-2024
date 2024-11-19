extends Control

signal chosen(card: PlayableCard)

var mouse_over := false

@onready var playable_card: PlayableCard = $PlayableCard


func _ready() -> void:
	playable_card.mouse_entered.connect(_on_mouse_entered)
	playable_card.mouse_exited.connect(_on_mouse_exited)


func _input(event):
	if event.is_action_pressed("mouse_click") and mouse_over:
		print("Clicked On Object " + str(randf()))
		chosen.emit(playable_card)


func _on_mouse_entered(card: PlayableCard) -> void:
	print("_on_mouse_entered")
	mouse_over = true
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(playable_card, "scale", Vector2.ONE * 1.375, 0.75)


func _on_mouse_exited(card: PlayableCard) -> void:
	print("_on_mouse_exited")
	mouse_over = false
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CIRC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(playable_card, "scale", Vector2.ONE, 0.75)
