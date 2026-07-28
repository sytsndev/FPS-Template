extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	#player.animation_player.play("run")
	pass


func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !player.movement.is_dashing:
		player.movement.start_dash(direction)
	player.movement.dash_move(direction, delta)
	
	if not player.is_on_floor() and !player.movement.is_dashing:
		finished.emit(FALLING)
	elif is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
		finished.emit(IDLE)
