extends Node3D
class_name CameraLean

@export var attack_damping: float = 0.5
@export var decay_damping: float = 0.2
@export var strength: float = 0.075

var _damped_acceleration: Vector3 = Vector3.ZERO
var _damped_acceleration_vel: Vector3 = Vector3.ZERO


func _ready() -> void:
	initialize()


func initialize() -> void:
	_damped_acceleration = Vector3.ZERO
	_damped_acceleration_vel = Vector3.ZERO
	rotation = Vector3.ZERO
	rotation_degrees = Vector3.ZERO


func update_lean(delta: float, acceleration: Vector3, up: Vector3 = Vector3.UP) -> void:
	# 1. Project acceleration onto plane perpendicular to up (ignore vertical accel)
	var planar_accel: Vector3 = acceleration - up * acceleration.dot(up)

	# 2. Choose damping: faster when increasing accel, slower when decaying
	var damping := attack_damping
	if planar_accel.length() <= _damped_acceleration.length():
		damping = decay_damping

	# 3. Smooth damp towards target acceleration (Unity's Vector3.SmoothDamp analogue)
	_damped_acceleration = _vector3_smooth_damp(
		_damped_acceleration,
		planar_accel,
		_damped_acceleration_vel,
		damping,
		INF,
		delta
	)

	if _damped_acceleration.length_squared() <= 0.000001:
		# Nothing significant, reset to parent’s rotation
		rotation_degrees = Vector3.ZERO
		return

	# 4. Lean axis: perpendicular to acceleration and up
	var lean_axis: Vector3 = _damped_acceleration.normalized().cross(up).normalized()

	# 5. Reset to parent's basis, then apply lean
	# local rotation identity
	transform.basis = get_parent().global_transform.basis

	var angle_deg := -_damped_acceleration.length() * strength
	var angle_rad := deg_to_rad(angle_deg)

	# Rotate around lean_axis (in world space)
	transform.basis = Basis(lean_axis, angle_rad) * transform.basis

	# Make transform local again relative to parent
	global_transform = Transform3D(transform.basis, global_transform.origin)


func _vector3_smooth_damp(current: Vector3, target: Vector3, velocity: Vector3,
						  smooth_time: float, max_speed: float, delta: float) -> Vector3:
	# Approximate Unity's Vector3.SmoothDamp
	smooth_time = max(0.0001, smooth_time)
	var omega := 2.0 / smooth_time

	var x := omega * delta
	var exp := 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)

	var change: Vector3 = current - target
	var original_to: Vector3 = target

	# Clamp max speed
	var max_change := max_speed * smooth_time
	var max_change_sq := max_change * max_change
	if change.length_squared() > max_change_sq:
		change = change.normalized() * max_change

	target = current - change
	var temp: Vector3 = (velocity + omega * change) * delta
	velocity = (velocity - omega * temp) * exp
	var output: Vector3 = target + (change + temp) * exp

	# Prevent overshoot
	var orig_minus_current: Vector3 = original_to - current
	var output_minus_orig: Vector3 = output - original_to
	if orig_minus_current.dot(output_minus_orig) > 0.0:
		output = original_to
		velocity = (output - original_to) / delta

	_damped_acceleration_vel = velocity
	return output
