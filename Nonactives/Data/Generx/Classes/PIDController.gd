class_name PIDController
extends RefCounted

# PID coefficients
var k_p: float = 1.0
var k_i: float = 0.0
var k_d: float = 0.0

func _init(p: float, i: float, d: float) -> void:
	k_p = p
	k_i = i
	k_d = d

# Internal variables
var integral: float = 0.0
var previous_error: float = 0.0

# Calculate the PID output
func calculate(target: float, current: float, delta: float) -> float:
	var error = target - current
	integral += error * delta
	var derivative = (error - previous_error) / delta
	previous_error = error
	return k_p * error + k_i * integral + k_d * derivative
