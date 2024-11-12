extends Action


func activate(game_state: Dictionary):
	actor = game_state.get("actor")
	cost = game_state.get("cost")
	
	actor.spend_mana(cost)
	actor.add_defense(1)
