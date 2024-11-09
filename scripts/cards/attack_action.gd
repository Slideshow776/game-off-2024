extends RefCounted


func activate(game_state: Dictionary):
	game_state.get("caster").spend_mana(1)	
	for target in game_state.get("targets"):
		target.take_damage(1)
