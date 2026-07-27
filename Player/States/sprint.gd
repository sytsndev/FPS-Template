extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	#player.animation_player.play("run")
	pass


func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	player.movement.sprint(direction, delta)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif (Input.is_action_just_released("sprint") or player.is_crouching) and player.state_run():
		finished.emit(RUNNING)
	elif player.state_jump():
		finished.emit(JUMPING)
	elif is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
		finished.emit(IDLE)
