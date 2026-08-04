extends PlayerState

var grapple_point: Vector3
var grappling := false
var reel_speed := 20.0
var swing_force := 15.0
var max_grapple_distance := 0.0

func enter(previous_state_path: String, data := {}) -> void:
	grapple_point = player.grapple_cast.get_collision_point()
	grappling = true
	max_grapple_distance = player.global_position.distance_to(grapple_point)

func physics_update(delta: float) -> void:
	if grappling:
		var to_anchor = grapple_point - player.global_position
		var distance = to_anchor.length()

		if distance > 0.001:
			var rope_dir = to_anchor / distance

			# gravity should still apply
			player.velocity += player.get_gravity() * delta

			# pull toward anchor
			player.velocity += rope_dir * reel_speed * delta

			# optional swing control
			var input_dir = Input.get_vector("left", "right", "forward", "back")
			var side_force = Vector3(input_dir.x, 0, input_dir.y)
			player.velocity += side_force * swing_force * delta

			# stop exceeding max rope length
			if distance > max_grapple_distance:
				player.global_position = grapple_point - rope_dir * max_grapple_distance

				var outward_velocity = player.velocity.dot(-rope_dir)
				if outward_velocity > 0.0:
					player.velocity += rope_dir * outward_velocity

		player.move_and_slide()

	if player.state_grapple():
		finished.emit(GRAPPLE)
	elif player.state_jump():
		finished.emit(JUMPING)
	elif player.state_sprint():
		finished.emit(SPRINT)

func exit() -> void:
	grappling = false
