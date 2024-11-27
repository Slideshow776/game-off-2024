class_name CardData
extends Resource

@export var title: String
@export var description: String
@export var cost: int
@export var image: CompressedTexture2D
@export var type: Type
@export var actions: Array[GDScript] = []

enum Type { ATTACK, DEFENSE, SKILL, SECRET }
var colour: Card.Colour
