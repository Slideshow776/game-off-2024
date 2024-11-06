class_name CardWithID
extends Resource

var id: int
var card: UsableCard


func _init(_id: int, _card) -> void:
	id = _id
	card = _card
