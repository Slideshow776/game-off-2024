@tool
class_name Hand
extends Node2D

signal card_activated(card: PlayableCard)

@export var hand_radius := 100.0 # TODO: @export_range ?
@export var card_angle := -90.0 # TODO: @export_range?
@export var angle_limit := 20.0
@export var max_card_spread_angle = 5.0
@export var playable_card_scene: PackedScene

var cards: Array[PlayableCard] = []
var touched: Array[PlayableCard] = []
var current_selected_card_index := -1

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _process(delta: float) -> void:
	for card in cards:
		current_selected_card_index = -1
		card.unhighlight()
			
	if not touched.is_empty():
		var highest_touched_index := -1
		
		for touched_card in touched:
			highest_touched_index = max(highest_touched_index, cards.find(touched_card))
		
		if highest_touched_index >= 0 and highest_touched_index < cards.size():
			cards[highest_touched_index].highlight()
			current_selected_card_index = highest_touched_index
	
	if (collision_shape_2d.shape as CircleShape2D).radius != hand_radius:
		(collision_shape_2d.shape as CircleShape2D).set_radius(hand_radius)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click") and current_selected_card_index >= 0:
		var card = cards[current_selected_card_index]
		card_activated.emit(card)
		current_selected_card_index = -1


func empty() -> void:
	current_selected_card_index = -1
	for card in cards:
		card.queue_free()
	cards.clear()
	touched.clear()


func remove_card(index: int) -> PlayableCard:
	var card = cards[index]
	cards.remove_at(index)
	remove_child(card)
	touched.remove_at(touched.find(card))
	_reposition_cards()
	return card


func remove_by_entity(card: PlayableCard) -> PlayableCard:
	var remove_index = cards.find(card)
	return remove_card(remove_index)


func add_card(card_data: CardData) -> void:
	var playable_card = playable_card_scene.instantiate()
	cards.push_back(playable_card)
	add_child(playable_card)
	playable_card.load_card_data(card_data)	
	playable_card.mouse_entered.connect(_handle_card_touched)
	playable_card.mouse_exited.connect(_handle_card_untouched)
	_reposition_cards()


func _handle_card_touched(card: PlayableCard) -> void:
	touched.push_back(card)


func _handle_card_untouched(card: PlayableCard) -> void:
	touched.remove_at(touched.find(card))


func _reposition_cards() -> void:
	var card_spread = min(angle_limit / cards.size(), max_card_spread_angle)
	var current_angle = -(card_spread * (cards.size() - 1)) / 2 - 90 
	for card in cards:
		_update_card_transform(card, current_angle)
		current_angle += card_spread


func _update_card_transform(card: PlayableCard, angle_in_deg: float) -> void:
	card.set_position(_get_card_position(angle_in_deg))
	card.set_rotation(deg_to_rad(angle_in_deg + 90))


func _get_card_position(angle_in_degree: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(angle_in_degree))
	var y: float = hand_radius * sin(deg_to_rad(angle_in_degree))
	return Vector2(x, y)
