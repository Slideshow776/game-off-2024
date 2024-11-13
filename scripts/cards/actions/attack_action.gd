extends Action


func activate(game_state: Dictionary):
	actor = game_state.get("actor") as Character
	cost = game_state.get("cost")
	
	actor.spend_mana(cost)
	actor.deal_damage_animation()
	for target in (game_state.get("targets") as Array[Character]):
		target.take_damage(1)
