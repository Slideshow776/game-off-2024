class_name CardContainer
extends Container

const SCALE = 0.95
const CARD_COMPONENT_POSITION: Vector2 = Vector2(102, 123)

@export var playable_card_scene: PackedScene

var playable_card: PlayableCard

var card: CardData:
	set(value):
		if !is_node_ready():
			await ready
			
		card = value
		playable_card = playable_card_scene.instantiate()
		add_child(playable_card)
		playable_card.set_position(CARD_COMPONENT_POSITION)
		playable_card.load_card_data(card)
		playable_card.scale = Vector2.ONE * SCALE
