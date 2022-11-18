extends Node
var time = 0
func clamp_vector3(vector3,minimum,maximum):
	var x = clamp(vector3.x,minimum,maximum)
	var y = clamp(vector3.y,minimum,maximum)
	var z = clamp(vector3.z,minimum,maximum)
	return Vector3(x,y,z)
func get_group_nodes(groupName):
	return get_tree().get_nodes_in_group(groupName)
func _process(delta):
	global.time += 1 * delta
