class_name Action
extends RefCounted

var actor: Character
var cost: int


func activate(game_state: Dictionary):
	actor = game_state.get("actor") as Character
	cost = game_state.get("cost")
