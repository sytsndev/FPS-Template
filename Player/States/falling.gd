extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if player.player_res.movement_type == MovementType.FLOATY:
		player.movement.fall_move(direction, delta)
	if player.player_res.movement_type == MovementType.WISH_DIR:
		player.movement.air_wish_dir_move(delta, input_dir)
	
	if player.state_wall_run():
		finished.emit(WALL_RUN)
	if player.state_dash():
		finished.emit(DASH)
	if player.state_jump():
		player.d_jump_count += 1
		finished.emit(JUMPING)
	if player.state_grapple():
		finished.emit(GRAPPLE)
	if player.is_on_floor():
		player.d_jump_count = 0
		if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
