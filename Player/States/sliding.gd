extends PlayerState

enum SlideType { 
	DASH_SLIDE,
	GLIDE_SLIDE
	}

func enter(previous_state_path: String, data := {}) -> void:
	if player.player_res.c_fov_change:
		player.camera_manager.smooth_change_fov(player.player_res.fov * 1.1)


func physics_update(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if player.player_res.slide_type == SlideType.GLIDE_SLIDE:
		glide_slide(direction, delta)
	elif player.player_res.slide_type == SlideType.DASH_SLIDE:
		dash_slide(direction, delta)
	
	if player.player_res.slide_type == SlideType.GLIDE_SLIDE:
		glide_exit_checks(input_dir)
	elif player.player_res.slide_type == SlideType.DASH_SLIDE:
		dash_exit_checks()


func dash_slide(direction: Vector3, delta: float):
	if !player.movement.is_sliding:
			player.movement.start_slide(direction)
	player.movement.slide_move(delta)


func glide_slide(direction: Vector3, delta: float):
		player.movement.move(direction, delta, player.player_res.sprint_speed)


func glide_exit_checks(input_dir: Vector2):
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


func dash_exit_checks():
	if not player.is_on_floor():
		finished.emit(FALLING)
	if player.movement.slide_timer <= 0.0:
		finished.emit(IDLE)


func exit() -> void:
	if !Input.is_action_pressed("crouch"):
		player.exit_crouch()
	if player.slide_reset_timer <= 0.0:
		player.slide_reset_timer = player.player_res.slide_delay
	print(player.slide_reset_timer)
	if player.player_res.c_fov_change:
		player.camera_manager.smooth_change_fov(player.player_res.fov)
