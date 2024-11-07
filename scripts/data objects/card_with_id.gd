class_name CardWithID
extends Resource

var id: int
var card: CardData


func _init(temp_id: int, temp_card: CardData) -> void:
	id = temp_id
	card = temp_card
