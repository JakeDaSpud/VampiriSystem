extends Area3D

var _doorOpened : bool = false
var _opening : bool = false

@export_category("Door Settings")
# FOR NOW I AM ASSUMING THAT IS THE NODE WE ARE ATTACHED TO??
# The Area3D that the player has to enter
@export var collision_trigger : Area3D = null

# The door you want to rotate to open / close
@export var target_door : Node3D = null
@export var target_door_rotation : float = 120
@export var open_speed : float = 70

# Clockwise = -open_speed
# Anti-Clockwise = open_speed
@export var turns_clockwise : bool = true

# The Enemies the player has to kill
@export_category("Enemy Requirements")
@export var enemies_to_kill_trigger : Array = []
@export var enemies_must_be_dead : bool = false

# HOW TO DO KEY SYSTEM
# The Player will have public bools hasYellow hasRed hasBlue etc.
# When the Player walks into the Area3D, this script will check if that bool is true, and if this door requires it
@export_category("Key Requirements")
@export var requires_red : bool = false
@export var requires_blue : bool = false
@export var requires_yellow : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if target_door == null:
		print("There is no Targeted Door to open!")
	
	if collision_trigger == null:
		collision_trigger = self
	
	collision_trigger.body_entered.connect(_open_door)
	
	# Needed to turn clockwise
	if turns_clockwise:
		open_speed = open_speed * -1

func _process(_delta):
	# Don't do anything if the door is already opened!
	if !_doorOpened:
		if _opening:
			var currentRotation = target_door.rotation_degrees.y
			var targetRotation = target_door_rotation
			
			# Check if close to target rotation within a tolerance
			if abs(currentRotation - targetRotation) > 15:
				#target_door.rotation_degrees.y = lerp_angle(currentRotation, targetRotation, open_speed)
				
				target_door.rotation_degrees.y += open_speed * _delta
				print(target_door.rotation_degrees.y)
			
			elif abs(currentRotation - targetRotation) < 15:
				target_door.rotation_degrees.y = targetRotation
				_opening = false
				
				# Only triggers once
				_doorOpened = true

func _open_door(body):
	print("_open_door triggered")
	if (body.is_in_group("Player_Group") && !_doorOpened && !_opening):
		_opening = true
		print("Opening Door...")
