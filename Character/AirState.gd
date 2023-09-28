extends State

class_name AirState

@export var landing_state: State
@export var double_jump_animation: String = "double_jump"
@export var landing_animation: String = "fall"

var has_double_jumped: bool = false

func state_process(_delta):
	if (character.is_on_floor()):
		next_state = landing_state

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump") && !has_double_jumped):
		double_jump()
	if (event.is_action_released("jump")):
		jump_cut()

func double_jump():
	character.velocity.y = utils.double_jump_velocity
	playback.travel(double_jump_animation)
	has_double_jumped = true

func jump_cut():
	if character.velocity.y < -150:
		character.velocity.y = -150

func on_exit():
	if (next_state == landing_state):
		playback.travel(landing_animation)
		has_double_jumped = false
