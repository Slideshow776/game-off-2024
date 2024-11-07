class_name CardContainer
extends Container

const CARD_COMPONENT_POSITION: Vector2 = Vector2(102, 123)
var usuable_card: UsableCard

var card: CardData:
	set(temp):
		if !is_node_ready():
			await ready
			
		card = temp
		usuable_card = usuable_card_scene.instantiate()
		add_child(usuable_card)
		usuable_card.set_position(CARD_COMPONENT_POSITION)
		usuable_card.load_card_data(card)

@onready var usuable_card_scene = preload("res://scenes/cards/UsableCard.tscn")
