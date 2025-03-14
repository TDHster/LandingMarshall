extends Camera3D

@export var target: Node3D  # Перетащи сюда куб в инспекторе

func _process(delta):
	if target:
		look_at(target.global_transform.origin)
