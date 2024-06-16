extends CharacterBody3D

# Gun Animation Ref
@onready var animated_sprite_2d = $CanvasLayer/GunBase/AnimatedSprite2D
# Raycast Ref
@onready var ray_cast_3d = $RayCast3D
# Gunshot Sound ref
@onready var shoot_sound = $ShootSound

const SPEED = 5.0
const MOUSE_SENSITIVITY = 0.25
const MASTER_VOLUME = 0
const GAME_VOLUME = MASTER_VOLUME - 10

var can_shoot = true
var dead = false
#var interpolation_factor = 0.0

# Runs when Player node is added to scene / instantiated
func _ready():
	# Change volume of shooting sound
	shoot_sound.volume_db = GAME_VOLUME
	
	# Hide mouse and trap to screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Get animated sprite 2d, signal is emitted when animation is finished, use it to call shoot_anim_done()
	animated_sprite_2d.animation_finished.connect(shoot_anim_done)
	# When button up / release signal is emitted from the DeathScreen button, run restart()
	$CanvasLayer/DeathScreen/Panel/OnDeathRestartButton.button_up.connect(restart)

# Runs when input happens
func _input(event):
	
	# Dead -> No input
	if dead:
		return
		
	# Mouse moved
	if event is InputEventMouseMotion:
		# Change facing direction vector by mouse sensitivity * amount moved
		rotation_degrees.y -= event.relative.x * MOUSE_SENSITIVITY

func _process(delta):
	
	# Exit game
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	# Restart game
	if Input.is_action_just_pressed("restart"):
		restart()
		
	# Player is dead
	if dead:
		return
		
	# Player shoots
	if Input.is_action_just_pressed("shoot"):
		shoot()

# Fixed update from Unity, 60 times / second
func _physics_process(delta):
	
	# Player dead, don't do anything
	if dead:
		
		# Gradually increase interpolation factor
		#interpolation_factor += delta / 0.2
		
		# Clamp the value to be 0.0 to 1.0
		#interpolation_factor = clamp(interpolation_factor, 0.0, 1.0)
		
		# Lerp Camera to turn head
		if $Camera3D.rotation.z < deg_to_rad(80):
			
			var next_delta_rotate_z
			
			# Three levels of falling speed, determined by how far you're leaning
			if $Camera3D.rotation.z < deg_to_rad(15):
				next_delta_rotate_z = ease(0.1, 2)
			elif $Camera3D.rotation.z < deg_to_rad(35):
				next_delta_rotate_z = ease(0.15, 2)
			else:
				next_delta_rotate_z = ease(0.15, 1.5)
			
			if $Camera3D.position.y >= 0.20:
				# Lerp Camera to hit ground
				# From pos.y 1.5m to 0.2m
				# Very choppy this way
				# Old Way (1)
				#$Camera3D.position.y = (lerp_angle(1.5, 0.2, next_delta_rotate_z*10))
				
				# Old Way (2)
				$Camera3D.position.y = $Camera3D.position.y - clamp($Camera3D.rotation.z, 0.0, 1.0) + 0.2
				
				# Hybrid Way (3)
				#$Camera3D.position.y = $Camera3D.position.y - lerp_angle(1.5, 0.2, next_delta_rotate_z*10)
			else:
				$Camera3D.position.y = 0.19
			
			$Camera3D.rotate_z(lerp_angle(0.0, deg_to_rad(90), next_delta_rotate_z))
			
			#var target_rotation = cubic_interpolate(0.0, deg_to_rad(180), deg_to_rad(-180), deg_to_rad(720), interpolation_factor)
			#$Camera3D.rotation.z = target_rotation
			
			# Smooth linear head tilt
			#$Camera3D.rotate_z(lerp(0.0, deg_to_rad(90), 0.05))
			
			# OLD WAY OF TRYING TO CURVE IT
			#$Camera3D.rotate_z(cubic_interpolate(0.0, deg_to_rad(90), 0, deg_to_rad(90), 0.1))
			
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") * 2
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	else:	
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func restart():
	get_tree().reload_current_scene()

func shoot():
	if !can_shoot:
		# Just do nothing
		return
	can_shoot = false
	
	# Play gun shoot animation
	animated_sprite_2d.play("shoot")
	
	# Play gun shoot sound
	shoot_sound.play()
	
	if ray_cast_3d.is_colliding() and ray_cast_3d.get_collider().has_method("kill"):
		ray_cast_3d.get_collider().kill()

func shoot_anim_done():
	can_shoot = true

func kill():
	dead = true
	# Activate DeathScreen
	$CanvasLayer/DeathScreen.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
