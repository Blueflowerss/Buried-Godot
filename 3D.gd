extends Spatial

#load weather
var snowWeather = preload("res://snowWeather.tscn")
var playerScene = preload("res://Player.tscn")
var player
signal weatherChange
enum weatherTypes {
	SNOW,
	RAIN,
	CLEAR
}
var currrentWeather = weatherTypes.CLEAR
func _ready():
	if len(global.get_group_nodes("spawnPoints")) <= 0:
		player = playerScene.instance()
		add_child(player)
	else:
		var spawnPoint = global.get_group_nodes("spawnPoints")[0]
		player = playerScene.instance()
		player.translation = spawnPoint.translation
		add_child(player)
	emit_signal("weatherChange")
func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		currrentWeather = weatherTypes.SNOW
		emit_signal("weatherChange")
func _on_3DGamePlay_weatherChange():
	for weather in global.get_group_nodes("weather"):
		weather.queue_free()
	if currrentWeather == weatherTypes.SNOW:
		player.add_child(snowWeather.instance())
