class_name DeckViewWindow
extends ScrollContainer

@onready var card_container_scene: PackedScene = preload("res://scenes/ui/card_container.tscn")
@onready var h_flow_container: HFlowContainer = %HFlowContainer

var cached_card_containers: Array[CardContainer] = []


func clear_display():
	for child in h_flow_container.get_children():
		#child.remove_child(child.usable_card)
		h_flow_container.remove_child(child)


func display_card_list(cardsWithID: Array[CardWithID]) -> void:
	clear_display()
	
	while cached_card_containers.size() < cardsWithID.size():
		cached_card_containers.push_back(card_container_scene.instantiate() as CardContainer)
	
	for i in cardsWithID.size():
		var cardWithID: CardWithID = cardsWithID[i] as CardWithID
		var card_container: CardContainer = cached_card_containers[i]
		h_flow_container.add_child(card_container)
		card_container.card = cardWithID.card
