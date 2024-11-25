extends Action


func activate(game_state: Dictionary):
	super(game_state)
	actor.add_defense(1)
