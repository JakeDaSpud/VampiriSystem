extends CharacterBody3D

@onready var animated_sprite_3d = $AnimatedSprite3D
@export var move_speed : float = 2.0
@export var attack_range : float = 2.0

# Type specifying with player : CharacterBody3D, player is of that node type, other @export vars are shown doing it too above this
@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var dead = false

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	var dir = player.global_position - global_position
	dir.y = 9
	dir = dir.normalized()
	
	velocity = dir * move_speed
	move_and_slide()
	
func kill():
	dead = true
	$DeathSound.play()
	animated_sprite_3d.play("death")
	$CollisionShape3D.disabled = true
	# Might have to do this
	#collision_layer = 0
	#collision_mask = 0
