extends CharacterBody2D

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

@export var utils: CharacterUtils
@export var camera: Camera2D

var direction: Vector2 = Vector2.ZERO

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	velocity.y += get_gravity() * delta
	if velocity.y > 2000:
		velocity.y = 2000
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = get_horizontal_velocity()
	set_camera_position_x()
	move_and_slide()
	update_animation_parameters()
	update_facing_direction()

func get_gravity() -> float:
	return utils.jump_gravity if velocity.y < 0.0 else utils.fall_gravity

# returns a velocity based on acceleration and friction.
func get_horizontal_velocity() -> float:
	return utils.get_horizontal_velocity(
		direction,
		state_machine.character_can_move(),
		velocity
	)

func set_camera_position_x():
	camera.position.x = utils.calculate_target_camera_x(camera, direction)

# set current animation on AnimationPlayer
func update_animation_parameters():
	animation_tree.set("parameters/Move/blend_position", direction.x)

# set flip sprite based on is facing direction
func update_facing_direction():
	if (direction.x != 0):
		sprite.flip_h = (direction.x < 0)
