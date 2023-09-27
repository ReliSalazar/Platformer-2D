extends CharacterBody2D

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

## Jump "strength".
@export var jump_height: int = 90
## Time to reach max height. smaller = more "slow motion" sensation on jump.
@export_range(0.0, 1.0) var jump_time_to_peak: float = 0.25
## Time to reach floor. smaller = more "float" sensation on fall.
@export_range(0.0, 1.0) var jump_time_to_descend: float = 0.35

# velocity dependent from jump_time_to_peak. Used while jumping.
@onready var jump_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
# Velocity dependent from jump_time_to_descend. Used while falling.
@onready var fall_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) \
	* -1.0

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

var direction: Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	if velocity.y > 2000:
		velocity.y = 2000
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = get_horizontal_velocity()
	move_and_slide()
	update_animation_parameters()
	update_facing_direction()

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

# returns a velocity based on acceleration and friction.
func get_horizontal_velocity() -> float:
	if direction.x != 0 && state_machine.character_can_move():
		if velocity.y < 0.0:
			return lerp(velocity.x, direction.x * speed, air_acceleration)
		return lerp(velocity.x, direction.x * speed, acceleration)
	else:
		if velocity.y < 0.0:
			return lerp(velocity.x, 0.0, air_friction)
		return lerp(velocity.x, 0.0, friction)

# set current animation on AnimationPlayer
func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)

# set flip sprite based on is facing direction
func update_facing_direction():
	if (direction.x != 0):
		sprite.flip_h = (direction.x < 0)
