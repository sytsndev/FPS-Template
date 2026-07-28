class_name PlayerRes
extends Resource



@export_category("Player Setup")
@export var camera_pos: Vector3


@export_category("Player Settings")
@export var mouse_sens: float
@export var camera_lean: bool


@export_category("Player Movement Stats")
@export var speed: float = 10.0
@export var sprint_speed: float = 14.0
@export var crouch_speed: float = 6.0
@export var gravity: float = -40.0
@export var jump_gravity: float = -20.0
@export var jump_impulse: float = 10.0
@export var dash_impulse: float = 50.0
@export var dash_time: float = 0.15


@export_category("Player Movement Variables")
@export var max_double_jump_count: float = 1
