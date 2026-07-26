class_name PlayerRes
extends Resource



@export_category("Player Setup")
@export var camera_pos: Vector3


@export_category("Player Settings")
@export var mouse_sens: float


@export_category("Player Movement Stats")
@export var speed: float = 10.0
@export var crouch_speed: float = 6.0
@export var gravity: float = -40.0
@export var jump_gravity: float = -20.0
@export var jump_impulse: float = 10.0
