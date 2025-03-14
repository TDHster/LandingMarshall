extends Node3D

# Скорость вращения лопастей
@export var blade_speed: float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Вращение лопастей
	if has_node("Blade"):  # Замените "Blade" на имя узла лопастей
		get_node("Blade").rotate_y(blade_speed * delta)
