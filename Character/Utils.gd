extends Node

class_name CharacterUtils

## Jump "strength".
@export var jump_height: int = 80
## Time to reach max height.
@export_range(0.0, 1.0) var jump_time_to_peak: float = 0.35
## Time to reach floor.
@export_range(0.0, 1.0) var jump_time_to_descend: float = 0.4

# velocity dependent from jump_time_to_peak. Used while jumping.
@export var jump_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
	
# Velocity dependent from jump_time_to_descend. Used while falling.
@export var fall_gravity: float = \
	((-2.0 * jump_height) / (jump_time_to_descend * jump_time_to_descend)) \
	* -1.0

# velocity dependent from jump_time_to_peak.
@export var jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_peak) * -1.0

# velocity dependent from jump_time_to_descend.
@export var double_jump_velocity: float = \
	((2.0 * jump_height) / jump_time_to_peak * 0.7) * -1.0

## Horizontal player speed
@export var speed: int = 170
## Friction to slow down movement when stop horizontal motion
@export_range(0.0, 1.0) var friction: float = 0.25
## Acceleration to reach speed on horizontal movement
@export_range(0.0 , 1.0) var acceleration: float = 0.25
# Same as friction but on air so player could fast change direction
@export_range(0.0, 1.0) var air_friction: float = 0.3
# Same as acceleration but on air so player could fast change direction
@export_range(0.0 , 1.0) var air_acceleration: float = 0.3

@export var max_camera_position: int = 35
@export var camera_movement_factor: float = 0.9

func get_horizontal_velocity(
	direction: Vector2,
	character_can_move: bool, velocity: Vector2
) -> float:
	var target_velocity = direction.x * speed if character_can_move else 0.0
	var fric = friction if character_can_move else air_friction
	var acc = acceleration if character_can_move else air_acceleration
	
	if velocity.y < 0.0:
		return lerp(velocity.x, target_velocity, acc)
	else:
		return lerp(velocity.x, target_velocity, fric)


func calculate_target_camera_x(camera: Camera2D, direction: Vector2) -> float:
	var move_amount = 2.0 / camera_movement_factor
	var target_x = camera.position.x + (move_amount * direction.x)
	return clamp(target_x, -max_camera_position, max_camera_position)
