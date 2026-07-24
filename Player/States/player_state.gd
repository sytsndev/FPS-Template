class_name PlayerState extends State

const IDLE = "Idle"
const RUNNING = "Running"
const JUMPING = "Jumping"
const FALLING = "Falling"

var player: Player


func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func update(delta: float) -> void:
	ui_inputs()


func handle_input(event: InputEvent) -> void:
	if !player.is_multiplayer_authority() && player.is_multiplayer: return

	if event is InputEventMouseMotion:
		player.neck.rotate_y(-event.relative.x * player.player_res.mouse_sens)
		player.neck.rotation.x = 0
		player.neck.rotation.z = 0
		player.camera.rotate_x(-event.relative.y * player.player_res.mouse_sens)
		player.camera.rotation.x = clamp(
		player.camera.rotation.x,
		deg_to_rad(-90),
		deg_to_rad(90)
	)


func ui_inputs():
	if Input.is_action_just_released("ui_cancel") and not player.is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.is_paused = true
		#get_tree().paused = true
	elif Input.is_action_just_released("ui_cancel") and player.is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.is_paused = false
		get_tree().paused = false
