class_name GameController
extends Node2D

enum GameState {
	PLAYER_TURN,
	ENEMY_TURN,
	GAME_OVER,
	GAME_WON,
}

var current_state := GameState.PLAYER_TURN


func transition(next_state: GameState) -> void:
	current_state = next_state
	match current_state:
		GameState.PLAYER_TURN:
			pass
		GameState.ENEMY_TURN:
			pass
		GameState.GAME_OVER:
			pass
		GameState.GAME_WON:
			pass
		
