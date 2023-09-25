extends CharacterBody2D

## Jump "strength".
@export var jump_height: int = 400
## Time to reach max height. smaller = more "slow motion" sensation on jump.
@export_range(0.0, 1.0) var jump_time_to_peak: float = 0.25
## Time to reach floor. smaller = more "float" sensation on fall.
@export_range(0.0, 1.0) var jump_time_to_descend: float = 0.35

# velocity dependent from jump_time_to_peak.
@onready var jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_peak) * -1.0
# velocity dependent from jump_time_to_peak. Used while jumping.
@onready var jump_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
# Velocity dependent from jump_time_to_descend. Used while falling.
@onready var fall_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) \
	* -1.0

@export var speed: int = 1000
@export_range(0.0, 1.0) var friction: float = 0.25
@export_range(0.0 , 1.0) var acceleration: float = 0.25
@export_range(0.0 , 1.0) var air_acceleration: float = 0.5
@export_range(0.0, 1.0) var air_friction: float = 0.5

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	velocity.x = get_horizontal_velocity()
	move_and_slide()

# return a falling velocity based on jump time to peak or jump time to descend.
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

# used to set velicity.y when user press jump button.
func jump():
	velocity.y = jump_velocity

# returns a velocity based on acceleration and friction.
func get_horizontal_velocity() -> float:
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction != 0:
		if velocity.y < 0.0:
			return lerp(velocity.x, horizontal_direction * speed, air_acceleration)
		return lerp(velocity.x, horizontal_direction * speed, acceleration)
	else:
		if velocity.y < 0.0:
			return lerp(velocity.x, 0.0, air_friction)
		return lerp(velocity.x, 0.0, friction)
