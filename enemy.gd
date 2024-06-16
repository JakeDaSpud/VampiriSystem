extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@export var move_speed : float = 2.0
@export var attack_range : float = 1.5

# Type specifying with player : CharacterBody3D, player is of that node type, other @export vars are shown doing it too above this
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("Player_Group")
var dead = false

# Entity Loop
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	var dir = player.global_position - global_position
	dir.y = 0
	dir = dir.normalized()
	
	velocity = dir * move_speed
	
	animated_sprite_3d.play("run")
	
	move_and_slide()
	attempt_to_kill_player()

func attempt_to_kill_player():
	var dist_to_player = global_position.distance_to(player.global_position)
	
	# If distance is higher than the attack range, do nothing
	if dist_to_player > attack_range:
		return
	
	var eye_line = Vector3.UP * 1.5
	
	# This is how you create a raycast with two points and the collision mask (this enemy position, player position, on collision mask 1)
	var query = PhysicsRayQueryParameters3D.create(global_position + eye_line, player.global_position, 1)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	# If empty means this enemy has direct line of sight to player
	if result.is_empty():
		player.kill()

func kill():
	dead = true
	$DeathSound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
	# Might have to do this
	#collision_layer = 0
	#collision_mask = 0
