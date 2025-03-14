extends CharacterBody3D

#
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
#
#func _physics_process(delta: float) -> void:
	#pass
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.z = move_toward(velocity.z, 0, SPEED)
#
	#move_and_slide()
	
	

# Ссылка на AnimationPlayer
@export var animation_player: AnimationPlayer

func _ready() -> void:
	# Воспроизводим анимацию по умолчанию
	if animation_player and animation_player.has_animation("Continue landing"):
		animation_player.play("Continue landing")

func _process(delta: float) -> void:
	# Управление анимациями
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_pressed("ui_left"):  # Нажата клавиша влево
		if animation_player and animation_player.has_animation("move left"):
			animation_player.play("move left")
	elif Input.is_action_pressed("ui_right"):  # Нажата клавиша вправо
		if animation_player and animation_player.has_animation("move right"):
			animation_player.play("move right")
	elif Input.is_action_pressed("ui_rise"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("Move up"):
			animation_player.play("Move up")
	elif Input.is_action_pressed("ui_down"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("Move close"):
			animation_player.play("Move close")
	elif Input.is_action_pressed("ui_up"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("Move distant"):
			animation_player.play("Move distant")
	elif Input.is_action_pressed("ui_hover"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("Hover"):
			animation_player.play("Hover")
	elif Input.is_action_pressed("landing permitted"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("landing permit"):
			animation_player.play("landing permit")
	elif Input.is_action_pressed("landing prohibited"):  # Нажата клавиша 
		if animation_player and animation_player.has_animation("landing cancel"):
			animation_player.play("landing cancel")
	else:
	# Если ничего не нажато, возвращаемся к анимации по умолчанию
		if animation_player and animation_player.has_animation("Continue landing"):
			if not animation_player.is_playing() or animation_player.current_animation != "Continue landing":
				animation_player.play("Continue landing")
