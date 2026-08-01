class_name PlayerRes
extends Resource



@export_category("Player Setup")
@export var camera_pos: Vector3

@export_category("Player Settings")
@export var mouse_sens: float
@export var dash_reset_jump: bool
@export var wall_run_reset_jump: bool

@export_category("Camera Settings")
@export var c_lean: bool
@export var c_fov_change: bool
@export var fov: float = 90.0

@export_category("Wall Run")
@export var wall_run_delay: float = 0.5

@export_category("Running")
@export var speed: float = 10.0
@export var crouch_speed: float = 6.0

@export_category("Sprint")
@export var sprint_speed: float = 14.0

@export_category("Jump")
@export var jump_gravity: float = -20.0
@export var jump_impulse: float = 11.0

@export_category("Dash")
@export var dash_impulse: float = 50.0
@export var dash_time: float = 0.15

@export_category("General")
@export var gravity: float = -40.0

@export_category("Player Movement Variables")
@export var max_double_jump_count: float = 1
@export var max_dash_count: float = 2
