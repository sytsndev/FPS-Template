extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.player_res.c_fov_change:
		player.camera_manager.smooth_change_fov(player.player_res.fov * 1.2)
	#player.animation_player.play("run")
	pass


func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !player.movement.is_dashing:
		player.movement.start_dash(direction)
	player.movement.dash_move(delta)
	
	if !player.movement.is_dashing:
		finished.emit(FALLING)


func exit() -> void:
	player.movement.dash_dir = Vector3.ZERO
	player.velocity = Vector3.ZERO
	if player.player_res.c_fov_change:
		player.camera_manager.smooth_change_fov(player.player_res.fov)
