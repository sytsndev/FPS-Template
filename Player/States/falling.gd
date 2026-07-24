extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass
func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * player.player_res.speed
		player.velocity.z = direction.z * player.player_res.speed 

	if player.velocity.y > 0.0:
		player.velocity.y += player.player_res.jump_gravity * delta
	else:
		player.velocity.y += player.player_res.gravity * delta
	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			finished.emit(IDLE)
		else:
			finished.emit(RUNNING)
