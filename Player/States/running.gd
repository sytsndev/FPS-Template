extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	#player.animation_player.play("run")
	pass

func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * player.get_speed()
		player.velocity.z = direction.z * player.get_speed()
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.get_speed())
		player.velocity.z = move_toward(player.velocity.z, 0, player.get_speed())
	print(player.velocity)
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.state_jump():
		finished.emit(JUMPING)
	elif player.state_sprint():
		finished.emit(SPRINT)
	elif player.state_idle(input_dir):
		finished.emit(IDLE)
