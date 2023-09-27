extends State

class_name GroundState

@export var air_state: State

## Jump "strength".
@export var jump_height: int = 90
## Time to reach max height. smaller = more "slow motion" sensation on jump.
@export_range(0.0, 1.0) var jump_time_to_peak: float = 0.25
## Time to reach floor. smaller = more "float" sensation on fall.
@export_range(0.0, 1.0) var jump_time_to_descend: float = 0.35
# velocity dependent from jump_time_to_peak.

@export var jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_peak) * -1.0

@export var jump_animation: String = "jump"

func state_process(_delta):
	if (!character.is_on_floor()):
		go_to_air_state()

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump")):
		jump()

func jump():
	character.velocity.y = jump_velocity
	go_to_air_state()

func go_to_air_state():
	next_state = air_state
	playback.travel(jump_animation)
