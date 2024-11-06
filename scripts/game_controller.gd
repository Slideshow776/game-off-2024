class_name GameController
extends Node2D

enum GameState {
	PLAYER_TURN,
	ENEMY_TURN,
	GAME_OVER,
	GAME_WON,
}

var is_running := true
var current_state := GameState.PLAYER_TURN


func toggle_pause_and_resume() -> void:
	is_running = !is_running
	if is_running:
		pause()
	else:
		resume()


func pause() -> void:
	is_running = false


func resume() -> void:
	is_running = true


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
