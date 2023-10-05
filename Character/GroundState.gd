extends State

class_name GroundState

@export var air_state: State
@export var jump_animation: String = "jump"

func state_process(_delta):
	if (!character.is_on_floor()):
		go_to_air_state()

func state_input(event: InputEvent):
	if (event.is_action_pressed("jump")):
		jump()

func jump():
	character.velocity.y = utils.jump_velocity
	character.has_jumped = true
	go_to_air_state()

func go_to_air_state():
	next_state = air_state
	playback.travel(jump_animation)
