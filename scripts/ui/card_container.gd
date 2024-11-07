class_name CardContainer
extends Container

const CARD_COMPONENT_POSITION: Vector2 = Vector2(102, 123)
var usable_card: UsableCard

var card: CardData:
	set(card_temp):
		if !is_node_ready():
			await ready
			
		card = card_temp
		usable_card = usable_card_scene.instantiate()
		add_child(usable_card)
		usable_card.set_position(CARD_COMPONENT_POSITION)
		usable_card.load_card_data(card)

@onready var usable_card_scene = preload("res://scenes/cards/UsableCard.tscn")
