extends State

class_name GroundState

@export var air_state: State
@export var jump_animation: String = "jump"

var max_camera_position: int = 70
var camera_movement_factor: float = 0.9

func state_process(_delta):
	if (!character.is_on_floor()):
		go_to_air_state()
	
	if (Input.is_action_pressed("look_up")):
		move_camera("up")
	if (Input.is_action_just_released("look_up")):
		camera.position.y = 0
		
	if (Input.is_action_pressed("look_down")):
		move_camera("down")
	if (Input.is_action_just_released("look_down")):
		camera.position.y = 0
	

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump")):
		jump()

func jump():
	character.velocity.y = utils.jump_velocity
	go_to_air_state()

func go_to_air_state():
	next_state = air_state
	playback.travel(jump_animation)

func move_camera(direction):
	var move_amount = 2 / camera_movement_factor
	var target_y = camera.position.y

	if direction == "up":
		target_y = clamp(
			target_y - move_amount,
			-max_camera_position,
			max_camera_position
		)
		var new_global_position = camera.global_position.y - target_y
		if new_global_position < camera.limit_top:
			var dif = new_global_position + camera.limit_bottom
			target_y += dif

	elif direction == "down":
		target_y = clamp(
			target_y + move_amount,
			-max_camera_position,
			max_camera_position
		)
		var new_global_position = camera.global_position.y + target_y
		if new_global_position > camera.limit_bottom:
			var dif = new_global_position - camera.limit_bottom
			target_y -= dif

	camera.position.y = target_y
