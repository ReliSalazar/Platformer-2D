extends State

class_name RollState

@export var ground_state: State
@export var rolling_animation: String = "roll"
@export var end_roll_animation: String = "fall"

func state_process(_delta):
	can_move = false
	character.is_rolling = true
	character.velocity.x = utils.get_roll_velocity(character.facing_direction, character.velocity)

func _on_animation_tree_animation_finished(anim_name):
	if (anim_name == rolling_animation):
		can_move = true
		next_state = ground_state
		character.is_rolling = false
		playback.travel(end_roll_animation)
