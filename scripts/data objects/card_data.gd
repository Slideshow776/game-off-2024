class_name CardData
extends Resource

@export var title: String
@export var description: String
@export var cost: int
@export var image: CompressedTexture2D
@export var colour: Card.Colour
@export var type: String
@export var actions: Array[GDScript] = []
