extends PlayerState

var wr_info

func enter(previous_state_path: String, data := {}) -> void:
	print("enter")
	player.velocity.y = 0
	if player.player_res.wall_run_reset_jump:
		player.dash_count = 0
		player.d_jump_count = 0
	wr_info = player.movement.enter_wall_run()
	match wr_info.rays:
		"Left":
			player.camera_manager.smooth_rot_camera(Vector3(0, 0, deg_to_rad(-10.0)))
		"Right":
			player.camera_manager.smooth_rot_camera(Vector3(0, 0, deg_to_rad(10.0)))


func physics_update(delta: float) -> void:
	#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#var direction := (player.neck.basis * Vector3(input_dir.x, 0, input_dir.y)).nalized(
	player.movement.move(wr_info.run_dir, delta, player.player_res.speed)
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)
	if Input.is_action_just_pressed("move_back") or !player.state_wall_run or (Input.is_action_just_pressed("move_right") if wr_info.rays == "Left" else Input.is_action_just_pressed("move_left")):
		finished.emit(FALLING)
	#if player.is_on_floor():
		#player.d_jump_count = 0
		#if is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0):
			#finished.emit(IDLE)
		#else:
			#finished.emit(RUNNING)

func exit() -> void:
	match wr_info.rays:
		"Left":
			for ray in player.left_wall_run_rays:
				player.remove_child(ray)
				player.wall_run_container.add_child(ray)
				ray.rotation = Vector3.ZERO
		"Right":
			for ray in player.right_wall_run_rays:
				player.remove_child(ray)
				player.wall_run_container.add_child(ray)
				ray.rotation = Vector3.ZERO
	player.camera_manager.smooth_rot_camera(Vector3.ZERO)
	player.wr_reset_timer = player.player_res.wall_run_delay
