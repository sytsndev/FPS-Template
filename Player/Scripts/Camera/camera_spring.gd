extends Node3D
class_name CameraSpring

@export_range(0.01, 5.0) var half_life: float = 0.075
@export var frequency: float = 18.0

@export var angular_displacement: float = 2.0   # degrees
@export var linear_displacement: float = 0.05   # positional scale

var spring_position: Vector3
var spring_velocity: Vector3 = Vector3.ZERO
var initialized := false


func _ready() -> void:
	initialize()


func initialize() -> void:
	spring_position = global_position
	spring_velocity = Vector3.ZERO
	initialized = true


func _process(delta: float) -> void:
	if not initialized:
		initialize()

	# Target is this node’s current global position (driven by player rig)
	var target: Vector3 = global_position
	_spring(spring_position, spring_velocity, target, half_life, frequency, delta)

	# Offset from current position to spring mass
	var local_spring_position: Vector3 = spring_position - global_position

	# Choose "up": usually world up
	var up: Vector3 = Vector3.UP
	var spring_height: float = local_spring_position.dot(up)

	# Apply rotation (tilt) and local position offset
	var rot := rotation_degrees
	rot.x = -spring_height * angular_displacement
	rotation_degrees = rot

	position = local_spring_position * linear_displacement


func _spring(current: Vector3, velocity: Vector3, target: Vector3,
			 half_life: float, frequency: float, time_step: float) -> void:
	# Port of your C# Spring function
	var damping_ratio := -log(0.5) / (frequency * half_life)
	var f := 1.0 + 2.0 * time_step * damping_ratio * frequency
	var oo := frequency * frequency
	var hoo := time_step * oo
	var hhoo := time_step * hoo
	var det_inv := 1.0 / (f + hhoo)
	var det_x: Vector3 = f * current + time_step * velocity + hhoo * target
	var det_v: Vector3 = velocity + hoo * (target - current)
	current = det_x * det_inv
	velocity = det_v * det_inv

	spring_position = current
	spring_velocity = velocity


func add_impulse(offset: Vector3) -> void:
	spring_position += offset
