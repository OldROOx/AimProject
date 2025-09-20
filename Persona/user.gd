extends CharacterBody3D

var mouse_sens = Vector2(0.1,0.1)
const SPEED = 5.0
const JUMP_VELOCITY = 3

var damage = 50
var spread = 10
var disparos = 0

@onready var pistola = $Camera3D/Pistola
var ui = load("res://Objetos/ui.tscn")

@onready var datos = $Camera3D/UI
var base_pos = Vector3.ZERO
var bullet_scene = preload("res://gbullet.tscn")
func goBackSpawn():
	position = Vector3(-13,5,-11)
	
func disparar():
	var bullet = bullet_scene.instantiate()  # crea la bala
	get_parent().add_child(bullet)  # agrega la bala a la escena principal

	# Posición inicial de la bala = posición de la escopeta
	bullet.global_position = pistola.global_position

	# Dirección hacia donde apunta la cámara
	bullet.direction = -pistola.global_transform.basis.z  # en Godot Z negativo apunta hacia adelante


func _ready():
	base_pos = pistola.position
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens.y))
		$Camera3D.rotate_x(deg_to_rad(-event.relative.y * mouse_sens.x))
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-80), deg_to_rad(80))
func _physics_process(delta):
	var target = base_pos
	
	if Input.is_action_just_pressed("click"):
		disparar()
		target = base_pos - Vector3(0, 0, -0.1)
		  # Ajusta el nombre si es distinto
	
	if Input.is_action_just_pressed("click"):
		var anim_player = pistola.get_node("AnimationPlayer")
		var start_time = 0.0
		var end_time = 0.87

		anim_player.play("Scene")
		anim_player.seek(start_time, true)

# Esperar la duración deseada y luego detener la animación
		await get_tree().create_timer(end_time - start_time).timeout
		anim_player.stop()

		
		

	#datos.ShowDatos(int(position.x), int(position.y), int(position.z))
	datos.ShowDatos(position.x, position.y, position.z)
	
	if position.y < -5:
		goBackSpawn()
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Izq", "Der", "Up", "Down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	
	if velocity != Vector3(0,0,0):
		target = base_pos - Vector3(0, 0, -0.09)
	else:
		pass
		
	pistola.position = pistola.position.lerp(target, 0.1)
	
	

	move_and_slide()
	datos.ShowVelocity(velocity)
	
