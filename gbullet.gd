extends Node3D


var speed = 4000.0
var direction = Vector3.ZERO

func _process(delta):
	# Mueve la bala en la dirección definida
	translate(direction * speed * delta)
	if position.length() > 100:
		queue_free()
