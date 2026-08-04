class_name Player extends CharacterBody3D





@export_category("Nodes")
@export var neck: Node3D
@export var camera: Node3D
@export var player_res: PlayerRes
@export var crouch_shape_cast: ShapeCast3D
@export var collision_shape: CollisionShape3D
@export var player_mesh: MeshInstance3D
@export var movement: Movement
@export var camera_lean: CameraLean
@export var camera_manager: CameraManager
@export var left_wall_run_rays: Array[RayCast3D]
@export var right_wall_run_rays: Array[RayCast3D]
@export var grapple_cast: RayCast3D

@onready var wall_run_container: Node3D = $Neck/WallRun

var is_crouching: bool = false
var exiting_crouching: bool = false

var d_jump_count: int = 0
var dash_count: int = 0
var wr_reset_timer: float = 0.0
var slide_reset_timer: float = 0.0

var is_paused: bool = false


func _ready() -> void:
	setup()


func _process(delta: float) -> void:
	wall_run_timer(delta)
	slide_timer(delta)

#region Setup

func setup():
	camera.position = player_res.camera_pos
	grapple_cast.target_position = player_res.grapple_dist

#endregion


#region Crouching


func enter_crouch_ground():
	if exiting_crouching:
		return
	is_crouching = true
	collision_shape.scale.y = collision_shape.scale.y / 1.5
	camera.position = player_res.camera_pos / 1.5
	velocity.y += -50.0
	move_and_slide()


func  enter_crouch_air():
	collision_shape.scale.y = collision_shape.scale.y / 1.5
	camera.position = player_res.camera_pos / 1.5
	is_crouching = true


func exit_crouch():
	if movement.is_sliding:
		return
	is_crouching = false
	collision_shape.scale.y = collision_shape.scale.y * 1.5
	camera.position = player_res.camera_pos
	
	exiting_crouching = false


#endregion


#region State Change Checks

func state_jump():
	if !player_res.double_jump and !is_on_floor():
		return false
	if player_res.auto_bhop and Input.is_action_pressed("jump") and is_on_floor():
		return true
	return Input.is_action_just_pressed("jump") and player_res.max_double_jump_count > d_jump_count

func state_run():
	return Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward" )or Input.is_action_pressed("move_back")

func state_sprint():
	if !player_res.sprint:
		return false
	return !is_crouching and Input.is_action_pressed("sprint") and (Input.is_action_pressed("move_forward" ))

func state_idle(input_dir: Vector2):
	return is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0)

func state_slide():
	if !player_res.slide or !player_res.crouch:
		return false
	return Input.is_action_just_pressed("crouch")

func state_dash():
	if !player_res.dash:
		return false
	return Input.is_action_just_pressed("dash") and dash_count < player_res.max_dash_count

func state_wall_run():
	if !player_res.wall_run:
		return false
	return (left_wall_run_rays.all(func(ray): return ray.is_colliding()) or right_wall_run_rays.all(func(ray): return ray.is_colliding())) and wr_reset_timer == 0.0

func state_grapple():
	if !player_res.grapple:
		return false
	return Input.is_action_just_pressed("grapple") and grapple_cast.is_colliding()

#endregion


func get_speed():
	if is_crouching:
		return player_res.crouch_speed
	else:
		return player_res.speed

func wall_run_timer(delta: float):
	if is_on_floor():
		wr_reset_timer = 0.0
	if wr_reset_timer > 0.0:
		wr_reset_timer -= delta
		if wr_reset_timer <= 0.0:
			wr_reset_timer = 0.0


func slide_timer(delta: float):
	if slide_reset_timer > 0.0:
		slide_reset_timer -= delta
		if slide_reset_timer <= 0.0:
			slide_reset_timer = 0.0
