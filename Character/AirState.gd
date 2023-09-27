extends State

class_name AirState

@export var landing_state: State

## Jump "strength".
@export var jump_height: int = 90
## Time to reach max height. smaller = more "slow motion" sensation on jump.
@export_range(0.0, 1.0) var jump_time_to_peak: float = 0.25
## Time to reach floor. smaller = more "float" sensation on fall.
@export_range(0.0, 1.0) var jump_time_to_descend: float = 0.35

# velocity dependent from jump_time_to_peak.
@onready var jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_peak) * -1.0
# velocity dependent from jump_time_to_descend.
@onready var double_jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_descend) * -1.0

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
	character.velocity.y = double_jump_velocity
	playback.travel(double_jump_animation)
	has_double_jumped = true

func jump_cut():
	if character.velocity.y < -150:
		character.velocity.y = -150

func on_exit():
	if (next_state == landing_state):
		playback.travel(landing_animation)
		has_double_jumped = false
