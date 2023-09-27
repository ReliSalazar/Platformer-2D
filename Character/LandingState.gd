extends State

class_name LandingState

@export var landing_animation_name: String = "fall"
@export var ground_state: State

func state_process(_delta):
	if (character.is_on_floor()):
		next_state = ground_state

# This will be usefull for roll mechanic
# if you want to lock until animation finish do it like this:
func _on_animation_tree_animation_finished(_anim_name):
#	if (anim_name == landing_animation_name):
#		next_state = ground_state
	pass
