class_name Player extends CharacterBody3D


@export_category("Toggles")
@export var crouch: bool
@export var sprint: bool
@export var wall_run: bool
@export var slide: bool
@export var dash: bool
@export var double_jump: bool


@export_category("Nodes")
@export var neck: Node3D
@export var camera: Camera3D
@export var player_res: PlayerRes
@export var crouch_shape_cast: ShapeCast3D
@export var collision_shape: CollisionShape3D
@export var player_mesh: MeshInstance3D
@export var movement: Movement
@export var camera_lean: CameraLean
@export var camera_manger: CameraManager


var is_crouching: bool = false
var exiting_crouching: bool = false

var d_jump_count: int = 0
var dash_count: int = 0

var is_paused: bool = false


func _ready() -> void:
	setup()


#region Setup

func setup():
	camera.position = player_res.camera_pos

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
	is_crouching = false
	collision_shape.scale.y = collision_shape.scale.y * 1.5
	camera.position = player_res.camera_pos
	
	exiting_crouching = false


#endregion


#region State Change Checks

func state_jump():
	return Input.is_action_just_pressed("jump") and player_res.max_double_jump_count > d_jump_count

func state_run():
	return Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_forward" )or Input.is_action_pressed("move_back")

func state_sprint():
	return !is_crouching and Input.is_action_pressed("sprint") and (Input.is_action_pressed("move_forward" ))

func state_idle(input_dir: Vector2):
	return is_equal_approx(input_dir.x, 0.0) && is_equal_approx(input_dir.y, 0.0)
#endregion


func get_speed():
	if is_crouching:
		return player_res.crouch_speed
	else:
		return player_res.speed
