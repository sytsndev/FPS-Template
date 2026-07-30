extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	pass


func physics_update(delta: float) -> void:
	print("Check State")
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	player.movement.move(direction, delta, player.player_res.sprint_speed)
	
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif (Input.is_action_just_released("sprint") 
			or !player.is_crouching 
			or Input.is_action_just_released("move_forward") 
			or Input.is_action_just_pressed("move_back")
			) and player.state_run():
		finished.emit(RUNNING)
	elif Input.is_action_just_released("crouch"):
		finished.emit(SPRINT)
	elif player.state_jump():
		finished.emit(JUMPING)
	elif is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
		finished.emit(IDLE)


func exit() -> void:
	pass
