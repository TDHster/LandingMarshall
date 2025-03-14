extends CharacterBody3D

const SPEED = 2.0
const INERTIA = 0.995
const RISE_SPEED = 3.0
const multiple_start_speed = -3
const MAX_TILT_ANGLE = 30.0

const INPUT_HOLD_DELAY = 0.5  # Задержка перед движением (в секундах)

@export var camera: Camera3D

var initial_speed := Vector3.ZERO
var input_hold_time := {}  # Словарь для отслеживания удержания клавиш
var is_hovering := false  # Флаг, указывающий, остановлен ли объект

func _ready() -> void:
	var angle_deg := 30.0
	var angle_rad := deg_to_rad(angle_deg)

	var forward_speed := cos(angle_rad) * SPEED * multiple_start_speed
	var downward_speed := -sin(angle_rad) * SPEED

	initial_speed = Vector3(0, downward_speed, -forward_speed)
	velocity = initial_speed

func _physics_process(delta: float) -> void:
	# Проверка нажатия клавиши "ui_hover" (Пробел)
	if Input.is_action_pressed("ui_hover"):
		is_hovering = true
	else:
		is_hovering = false

	# Если объект в режиме hover, сбрасываем скорость и выходим
	if is_hovering:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	# Обновление времени удержания клавиш
	update_input_hold_times(delta)

	var direction := Vector3.ZERO

	if camera:
		var forward = -camera.global_transform.basis.z
		var right = camera.global_transform.basis.x

		# Проверяем, удерживаются ли клавиши достаточно долго
		if is_input_held_long_enough("ui_up"):
			direction += forward
		if is_input_held_long_enough("ui_down"):
			direction -= forward
		if is_input_held_long_enough("ui_right"):
			direction += right
		if is_input_held_long_enough("ui_left"):
			direction -= right

	direction.y = 0
	direction = direction.normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * (1 - INERTIA))
		velocity.z = move_toward(velocity.z, 0, SPEED * (1 - INERTIA))

	if Input.is_action_pressed("ui_rise"):
		velocity.y = RISE_SPEED
	elif Input.is_action_pressed("ui_descend"):
		velocity.y = -RISE_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, RISE_SPEED * (1 - INERTIA))

	move_and_slide()
	update_tilt(delta)

func update_input_hold_times(delta: float) -> void:
	var keys = ["ui_left", "ui_right", "ui_up", "ui_down"]
	for key in keys:
		if Input.is_action_pressed(key):
			input_hold_time[key] = input_hold_time.get(key, 0.0) + delta
		else:
			input_hold_time[key] = 0.0

func is_input_held_long_enough(action: String) -> bool:
	return input_hold_time.get(action, 0.0) >= INPUT_HOLD_DELAY

func update_tilt(delta: float) -> void:
	var target_tilt_x = -velocity.z / SPEED * MAX_TILT_ANGLE
	var target_tilt_z = velocity.x / SPEED * MAX_TILT_ANGLE

	rotation_degrees.x = -lerp(rotation_degrees.x, target_tilt_x, 0.15)
	rotation_degrees.z = -lerp(rotation_degrees.z, target_tilt_z, 0.15)
