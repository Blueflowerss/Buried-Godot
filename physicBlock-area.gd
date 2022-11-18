extends Area
var mat 
var omniLight
func _ready():
	mat = get_parent().get_node("MeshInstance").get_surface_material(0)
	mat.emission_enabled = false
	omniLight = get_parent().get_node("OmniLight")
	omniLight.visible = false
func _interact():
	if mat.emission_enabled == true:
		mat.emission_enabled = false
	else:
		mat.emission_enabled = true
		mat.emission_energy = 100
	if omniLight.visible:
		omniLight.visible = false
	else:
		omniLight.visible = true

