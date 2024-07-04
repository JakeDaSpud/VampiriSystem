extends Area3D

var _gateOpened : bool = false
var _opening : bool = false
var _gate

# Called when the node enters the scene tree for the first time.
func _ready():
	# Grab the gate in the scene
	_gate = $"../../Small Side Gate"
	# Set up the function
	body_entered.connect(open_gate)
	
func _process(_delta):
	if (_opening && _gate.rotation.y < 155):
		_gate.rotation.y = lerp_angle(_gate.rotation.y, deg_to_rad(160), 0.01)

func open_gate(body):
	if (body.is_in_group("Player_Group") && !_gateOpened):
		_opening = true
		# Only triggers once
		_gateOpened = true
		print("trying to open gate")
