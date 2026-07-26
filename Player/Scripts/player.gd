class_name Player extends CharacterBody3D

var speed := 10.0
var crouch_speed := 5.0
var gravity := -40.0
var jump_gravity := -20.0
var jump_impulse := 10.0
var is_paused: bool = false


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

var is_crouching: bool = false
var exiting_crouching: bool = false


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


func get_speed():
	if is_crouching:
		return player_res.crouch_speed
	else:
		return player_res.speed
