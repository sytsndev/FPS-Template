extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.player_res.jump_impulse
	#player.animation_player.play("jump")

func physics_update(delta: float) -> void:
	if player.velocity.y >= 0:
		finished.emit(FALLING)
