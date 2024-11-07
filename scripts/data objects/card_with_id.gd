class_name CardWithID
extends Resource

var id: int
var card: CardData


func _init(id: int, card: CardData) -> void:
	self.id = id
	self.card = card
