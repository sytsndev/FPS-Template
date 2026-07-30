class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"
const SPRINT = "Sprint"
const DOUBLE_JUMP = "DoubleJump"
const DASH = "Dash"
const SLIDING = "Sliding"


var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func update(delta: float) -> void:
	if player.crouch:
		crouch_inputs()
	ui_inputs()
	if player.is_on_floor() and (player.dash_count > 0 or player.d_jump_count > 0):
		player.dash_count = 0
		player.d_jump_count = 0


func handle_input(event: InputEvent) -> void:
	if !player.is_multiplayer_authority() && player.is_multiplayer: return

	if event is InputEventMouseMotion:
		player.neck.rotate_y(-event.relative.x * player.player_res.mouse_sens * 0.001)
		player.neck.rotation.x = 0
		player.neck.rotation.z = 0
		player.camera.rotate_x(-event.relative.y * player.player_res.mouse_sens * 0.001)
		player.camera.rotation.x = clamp(
		player.camera.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(90)
	)


func crouch_inputs():
	player.crouch_shape_cast.force_shapecast_update()

	if player.exiting_crouching and !player.crouch_shape_cast.is_colliding():
		player.exit_crouch()
	if Input.is_action_just_pressed("crouch") && player.is_on_floor():
		player.enter_crouch_ground()
	if Input.is_action_just_pressed("crouch") && !player.is_crouching:
		player.enter_crouch_air()
	if Input.is_action_just_released("crouch"):
		player.exiting_crouching = true


func ui_inputs():
	if Input.is_action_just_released("ui_cancel") and not player.is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.is_paused = true
		#get_tree().paused = true
	elif Input.is_action_just_released("ui_cancel") and player.is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.is_paused = false
		get_tree().paused = false
