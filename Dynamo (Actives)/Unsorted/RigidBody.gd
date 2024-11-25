extends RigidBody3D

# Proportional (k_p): This term determines the reaction to the current error. Increasing k_p will make the system respond more aggressively to the error but can cause overshooting.
# Integral (k_i): This term accounts for past errors. Increasing k_i can help eliminate steady-state errors but can cause the system to become unstable if too high.
# Derivative (k_d): This term predicts future errors based on the rate of change. Increasing k_d can help dampen the system's response and reduce overshooting.

@onready var pid_controller = preload("res://path_to_your_pid_controller.gd").new()

@export var target_position: Vector3
@export var movement_speed: float = 10.0

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var current_position = global_transform.origin
	var delta = state.get_step()
	
	var force_x = pid_controller.calculate(target_position.x, current_position.x, delta)
	var force_y = pid_controller.calculate(target_position.y, current_position.y, delta)
	var force_z = pid_controller.calculate(target_position.z, current_position.z, delta)
	
	var force = Vector3(force_x, force_y, force_z) * movement_speed
	state.apply_central_force(force)

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera()
	target_position = camera.project_position(mouse_pos, 10.0)
	
# Start with k_p: Set k_i and k_d to 0. Increase k_p until the system starts to oscillate, then reduce it to about half of that value.
# Adjust k_i: Increase k_i until any steady-state error is corrected in a reasonable time. Be cautious as too high a value can cause instability.
# Fine-tune with k_d: Increase k_d to reduce overshooting and dampen the response. If the response becomes too sluggish, reduce k_d
