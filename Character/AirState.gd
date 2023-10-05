extends State

class_name AirState

@export var landing_state: State
@export var double_jump_animation: String = "double_jump"
@export var landing_animation: String = "fall"

var max_coyote_time: float = 0.1
var coyote_time: float = 0.0

func state_process(delta):
	if (!character.is_on_floor() &&
	!character.has_jumped && !character.has_double_jumped):
		coyote_time += delta
	else:
		coyote_time = 0
	
	if (character.is_on_floor()):
		next_state = landing_state

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump") && !character.has_jumped):
		if (coyote_time < max_coyote_time):
			jump()
		else:
			double_jump()
	
	elif (event.is_action_pressed("jump") && !character.has_double_jumped):
		double_jump()
	
	if (event.is_action_released("jump")):
		jump_cut()

func jump():
	character.velocity.y = utils.jump_velocity
	character.has_jumped = true

func double_jump():
	character.velocity.y = utils.double_jump_velocity
	playback.travel(double_jump_animation)
	character.has_jumped = true
	character.has_double_jumped = true

func jump_cut():
	if character.velocity.y < -150:
		character.velocity.y = -150

func on_exit():
	if (next_state == landing_state):
		playback.travel(landing_animation)
		character.has_jumped = false
		character.has_double_jumped = false
