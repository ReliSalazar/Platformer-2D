extends State

class_name LandingState

@export var ground_state: State
@export var landing_animation_name: String = "fall"

func state_process(_delta):
	if (character.is_on_floor()):
		next_state = ground_state
