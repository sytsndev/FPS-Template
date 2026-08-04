extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	#player.animation_player.play("run")
	pass

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if player.player_res.movement_type == MovementType.FLOATY:
		player.movement.move(direction, delta, player.get_speed())
	elif player.player_res.movement_type == MovementType.WISH_DIR:
		player.movement.wish_dir_move(delta, input_dir, player.get_speed())
	else:
		player.movement.move(direction, delta, player.get_speed())
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.state_jump():
		finished.emit(JUMPING)
	elif player.state_sprint():
		finished.emit(SPRINT)
	elif player.state_idle(input_dir):
		finished.emit(IDLE)
