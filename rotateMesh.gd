extends MeshInstance
export var rotationSpeed = Vector3(0,0,0)
func _process(delta):
	rotation_degrees += rotationSpeed * delta
