class_name Movement
extends Node

@export var player: Player

var is_dashing := false
var dash_dir := Vector3.ZERO
var dash_timer := 0.0


func stop_move(delta: float):
	var prev_velocity := player.velocity
	
	player.velocity.y += player.player_res.gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.player_res.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.player_res.speed)
	player.move_and_slide()
	var acceleration := (player.velocity - prev_velocity) / delta

	if player.player_res.camera_lean:
		player.camera_lean.update_lean(delta, acceleration, Vector3.UP)

func fall_move(direction: Vector3, delta: float):
	var prev_velocity := player.velocity
	if direction:
		player.velocity.x = direction.x * player.player_res.speed
		player.velocity.z = direction.z * player.player_res.speed 

	if player.velocity.y > 0.0:
		player.velocity.y += player.player_res.jump_gravity * delta
	else:
		player.velocity.y += player.player_res.gravity * delta
	player.move_and_slide()
	var acceleration := (player.velocity - prev_velocity) / delta

	if player.player_res.camera_lean:
		player.camera_lean.update_lean(delta, acceleration, Vector3.UP)

func jump_move():
	player.velocity.y = player.player_res.jump_impulse


func sprint(direction: Vector3, delta: float):
	var prev_velocity := player.velocity
	if direction:
		player.velocity.x = direction.x * player.player_res.sprint_speed
		player.velocity.z = direction.z * player.player_res.sprint_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.player_res.sprint_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.player_res.sprint_speed)

	player.move_and_slide()
	var acceleration := (player.velocity - prev_velocity) / delta

	if player.player_res.camera_lean:
		player.camera_lean.update_lean(delta, acceleration, Vector3.UP)


func run(direction: Vector3, delta: float):
	var prev_velocity := player.velocity
	if direction:
		player.velocity.x = direction.x * player.get_speed()
		player.velocity.z = direction.z * player.get_speed()
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.get_speed())
		player.velocity.z = move_toward(player.velocity.z, 0, player.get_speed())
	print(player.velocity)
	player.move_and_slide()
	var acceleration := (player.velocity - prev_velocity) / delta

	if player.player_res.camera_lean:
		player.camera_lean.update_lean(delta, acceleration, Vector3.UP)


func start_dash(direction: Vector3) -> void:
	dash_dir = direction
	if direction == Vector3.ZERO:
		return
	
	is_dashing = true
	dash_dir = direction.normalized()
	dash_timer = player.player_res.dash_time
	player.velocity.y = 0
	player.velocity = dash_dir * player.player_res.dash_impulse
	player.dash_count += 1

func dash_move(delta: float):
	var prev_velocity := player.velocity
	
	if not is_dashing:
		return

	player.velocity = dash_dir * player.player_res.dash_impulse
	player.move_and_slide()

	dash_timer -= delta
	if dash_timer <= 0.0:
		is_dashing = false
	var acceleration := (player.velocity - prev_velocity) / delta

	if player.player_res.camera_lean:
		player.camera_lean.update_lean(delta, acceleration, Vector3.UP)
