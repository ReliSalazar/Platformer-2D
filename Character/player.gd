extends CharacterBody2D

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export var utils: CharacterUtils
@export var camera: Camera2D

var direction: Vector2 = Vector2.ZERO

var max_camera_position: int = 70
var camera_movement_factor: float = 0.5

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
	
	set_camera_position_x()
	set_camera_position_y()

func get_gravity() -> float:
	return utils.jump_gravity if velocity.y < 0.0 else utils.fall_gravity

# returns a velocity based on acceleration and friction.
func get_horizontal_velocity() -> float:
	return utils.get_horizontal_velocity(
		direction,
		state_machine.character_can_move(),
		velocity
	)

# set current animation on AnimationPlayer
func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)

# set flip sprite based on is facing direction
func update_facing_direction():
	if (direction.x != 0):
		sprite.flip_h = (direction.x < 0)

func set_camera_position_x():
	camera.position.x = utils.calculate_target_camera_x(camera, direction)

func set_camera_position_y():
	if (Input.is_action_pressed("look_up")):
		move_camera_y(-1) # Move camera up
	if (Input.is_action_just_released("look_up")):
		move_camera_y(0) # Resets camera position
		
	if (Input.is_action_pressed("look_down")):
		move_camera_y(1) # Move camera down
	if (Input.is_action_just_released("look_down")):
		move_camera_y(0) # Resets camera position

func move_camera_y(looking_direction: int):
	if looking_direction == 0:
		camera.position.y = 0
		return
	
	var move_amount = 2 / camera_movement_factor
	var target_y = camera.position.y

	if looking_direction == -1:
		target_y -= move_amount
	elif looking_direction == 1:
		target_y += move_amount
		
	camera.position.y = clamp(target_y, -max_camera_position, max_camera_position)
