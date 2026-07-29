extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.movement.fall_move(direction, delta)
	
	if Input.is_action_just_pressed("dash") and player.dash_count < player.player_res.max_dash_count:
		finished.emit(DASH)
	if player.state_jump():
		player.d_jump_count += 1
		finished.emit(JUMPING)
	if player.is_on_floor():
		player.d_jump_count = 0
		if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
