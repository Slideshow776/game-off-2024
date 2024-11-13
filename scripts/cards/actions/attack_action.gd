extends Action


func activate(game_state: Dictionary):
	super(game_state)
	actor.deal_damage_animation()
	for target in (game_state.get("targets") as Array[Character]):
		target.take_damage(1)
