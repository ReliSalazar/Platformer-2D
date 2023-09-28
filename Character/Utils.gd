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
