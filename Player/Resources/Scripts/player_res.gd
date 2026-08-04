class_name PlayerRes
extends Resource

enum SlideType { 
	DASH_SLIDE,
	GLIDE_SLIDE
	}

enum MovementType { 
	WISH_DIR,
	FLOATY
	}

@export_category("Player Setup")
@export var camera_pos: Vector3

@export_category("Toggles")
@export var crouch: bool
@export var sprint: bool
@export var wall_run: bool
@export var slide: bool
@export var dash: bool
@export var double_jump: bool

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
@export var movement_type: MovementType
@export var speed: float = 10.0
@export var crouch_speed: float = 6.0
@export var auto_bhop: bool = true
@export var toggle_sprint: bool


@export_category("Air Movement")
@export var air_cap: float = 0.85
@export var air_accel: float = 800.0
@export var air_move_speed: float = 500.0

@export_category("Ground Movement")
@export var ground_accel: float = 14.0
@export var ground_decel: float = 10.0
@export var ground_friction: float = 6.0


@export_category("Sprint")
@export var sprint_speed: float = 14.0

@export_category("Jump")
@export var jump_gravity: float = -20.0
@export var jump_impulse: float = 11.0

@export_category("Dash")
@export var dash_impulse: float = 50.0
@export var dash_time: float = 0.15

@export_category("Sliding")
@export var slide_impulse: float = 16.0
@export var slide_time: float = 0.5
@export var slide_type: SlideType
@export var slide_delay: float = 5.0

@export_category("General")
@export var gravity: float = -40.0

@export_category("Player Movement Variables")
@export var max_double_jump_count: float = 1
@export var max_dash_count: float = 2


@export_category("Grapple")
@export var grapple_dist: Vector3
