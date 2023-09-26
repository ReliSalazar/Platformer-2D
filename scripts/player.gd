extends CharacterBody2D

## Jump "strength".
@export var jump_height: int = 80
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
# velocity dependent from jump_time_to_peak. Used while jumping.
@onready var jump_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
# Velocity dependent from jump_time_to_descend. Used while falling.
@onready var fall_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) \
	* -1.0

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D

## Horizontal player speed
@export var speed: int = 220
## Friction to slow down movement when stop horizontal motion
@export_range(0.0, 1.0) var friction: float = 0.25
## Acceleration to reach speed on horizontal movement
@export_range(0.0 , 1.0) var acceleration: float = 0.25
# Same as friction but on air so player could fast change direction
@export_range(0.0, 1.0) var air_friction: float = 0.5
# Same as acceleration but on air so player could fast change direction
@export_range(0.0 , 1.0) var air_acceleration: float = 0.5

# used to control no more than once double jump
var has_double_jumped: bool = false
# used primarly to play landing animation
var was_in_air: bool = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		was_in_air = true
	else:
		has_double_jumped = false
		if was_in_air == true:
			land()
		was_in_air = false
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif not has_double_jumped:
			double_jump()
	
	if velocity.y > 2000:
		velocity.y = 2000
	
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = get_horizontal_velocity(horizontal_direction)
	move_and_slide()
	update_animations(horizontal_direction)
	update_facing_direction(horizontal_direction)

# return a falling velocity based on jump time to peak or jump time to descend.
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

# used to set velicity.y when user press jump button.
func jump():
	velocity.y = jump_velocity
	animation_player.play("jump")

# used to set velocity.y when user press jump button on air.
func double_jump():
	velocity.y = double_jump_velocity
	# TODO: add animation for double jump
	animation_player.play("jump")
	has_double_jumped = true

# uset to play land animation.
func land():
	# TODO: add animation for land
	animation_player.play("idle")

# returns a velocity based on acceleration and friction.
func get_horizontal_velocity(horizontal_direction) -> float:
	if horizontal_direction != 0:
		if velocity.y < 0.0:
			return lerp(velocity.x, horizontal_direction * speed, air_acceleration)
		return lerp(velocity.x, horizontal_direction * speed, acceleration)
	else:
		if velocity.y < 0.0:
			return lerp(velocity.x, 0.0, air_friction)
		return lerp(velocity.x, 0.0, friction)

# set current animation on AnimationPlayer
func update_animations(horizontal_direction):
	if not is_on_floor():
		animation_player.play("fall")
	else:
		if horizontal_direction == 0:
			animation_player.play("idle")
		else:
			animation_player.play("run")
		

# set flip sprite based on is facing direction
func update_facing_direction(horizontal_direction):
	if (horizontal_direction != 0):
		sprite.flip_h = (horizontal_direction < 0)
