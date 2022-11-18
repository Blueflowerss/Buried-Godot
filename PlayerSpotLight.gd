extends SpotLight



func _on_Player_lightToggle():
	if visible:
		visible = false
	else:
		visible = true
