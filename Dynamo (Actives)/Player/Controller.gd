extends RigidBody3D

var pid : PIDController = PIDController.new(1.42,0.32,0.0)

@export var chara : Character

var newtonslaw : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera : Camera3D
var hop_height : float = 1.5
var hop_force : float = 1.5
var unit_speed : float = .1
var target_pos : Vector3 = Vector3.ZERO
var view : Viewport
var dir : Vector3 = Vector3.ZERO
var sprite : AnimatedSprite3D

func _ready() -> void:
	view = self.get_tree().root
	camera = view.get_camera_3d()
	#self.custom_integrator = true
	sprite = self.get_child(1)
	#stageSprite(chara.length)

#func _input(e : InputEvent) -> void:
	#if (e is InputEventKey):
		#if (e.is_pressed()):
			#var strength : float = Input.get_action_strength("walk")
			#match (e.keycode):
				#87:
					#target_pos.z -= strength #FORWARD
				#68:
					#target_pos.x += strength #RIGHT
				#83:
					#target_pos.z += strength #BACK
				#65:
					#target_pos.x -= strength #LEFT
			
			
				

#func stageSprite(vt: float) -> void:
	#var aspectRatio = sprite.texture.get_width() / sprite.texture.get_height()
	#var newWidth = vt / aspectRatio
	#var factorHz = newWidth / sprite.texture.get_width()
	#var factorVt = (newWidth / aspectRatio) / sprite.texture.get_height()
	#sprite.offset.x = -newWidth / 2
	#self.scale_object_local(Vector3(factorHz,factorVt, self.scale.z))
	#self.offset = Vector2(self.texture.get_width()/2,self.texture.get_height()/2)

func launchUp(delta: float) -> void:
	sprite.play("jump")
	
	self.global_transform.origin.y += hop_force * delta
#func _physics_process(delta: float) -> void:
	#if (Input.is_action_pressed("jump")):
		#launchUp(delta)
	##dir = pos * (unit * delta)
	##self.global_transform.origin += dir;
	##self.position.x += dir.x
	##self.position.z += dir.z
	#var velocity_err = pos - self.linear_velocity
	#var correction_impulse = _pid.update(velocity_err, delta)
	#apply_central_impulse(correction_impulse)
#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#var cur_position = global_transform.origin
	#var delta = state.get_step()
	#
	#var force_x = pid.calculate(target_pos.x, cur_position.x, delta)
	#var force_z = pid.calculate(target_pos.z, cur_position.z, delta)
	#var force = Vector3(force_x, 0, force_z) * unit_speed
	#state.apply_central_force(force)
	
func _physics_process(delta: float):
	if (Input.is_action_pressed("jump")):
		launchUp(delta)
		#var mouse_pos = view.get_mouse_position()
		#var projected = camera.project_position(mouse_pos, 1.5)
		#projected.z += dir.z
		target_pos = dir
		self.global_transform.origin += target_pos * delta

func _process(delta: float):
		if (not sprite.is_playing() and sprite.frame == sprite.sprite_frames.get_frame_count("jump") - 1):
			sprite.speed_scale = 1.5
			sprite.play_backwards()
		elif(not sprite.is_playing()): sprite.speed_scale = 1
