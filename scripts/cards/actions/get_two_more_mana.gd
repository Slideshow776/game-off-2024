extends Action

func activate(game_state: Dictionary):
	super(game_state)
	actor.mana += 2
