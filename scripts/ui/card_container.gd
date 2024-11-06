class_name CardContainer
extends Container

const CARD_COMPONENT_POSITION := Vector2(102, 123)

var card: UsableCard:
	set(temp):
		if temp == null:
			print("card_container.gd => WARNING: tried to add a null card to card container")
			return
			
		card = temp
		card.position = CARD_COMPONENT_POSITION
		add_child(card)
