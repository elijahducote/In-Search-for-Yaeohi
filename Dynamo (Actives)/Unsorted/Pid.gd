class_name Pid3D
extends RefCounted

var _p: float
var _i: float
var _d: float

var _prev_err: Vector3
var _err_integral: Vector3

func _init(p: float, i: float, d: float) -> void:
	_p = p
	_i = i
	_d = d

func update(err: Vector3, delta: float) -> Vector3:
	_err_integral += err * delta
	var err_derivation = (err - _prev_err) / delta
	_prev_err = err
	return _p * err * _i * _err_integral * _d * err_derivation
