extends RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# No se usa body_entered en RigidBody3D
	pass

# Detectar colisiones en física
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var contact_count = state.get_contact_count()
	for i in range(contact_count):
		var collider = state.get_contact_collider_object(i)
		if collider:
			print("¡Chocamos con: ", collider.name, "!")
