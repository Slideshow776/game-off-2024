extends Action


func activate(game_state: Dictionary):
	actor = game_state.get("actor")
	cost = game_state.get("cost")
	
	actor.spend_mana(cost)
	for target in game_state.get("targets"):
		target.take_damage(1)
