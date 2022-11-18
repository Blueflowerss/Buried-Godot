extends KinematicBody
export var speed = 40
export var fall_acceleration = 20
export var skate_speed = 140
export var jump_height = 10
export (int,0,200) var push = 100 
var playerTransform = rotation
var newRotation = rotation
var velocity = Vector3.ZERO
var can_jump = false
var interactible = []
enum directions {
	NONE,
	LEFT,
	RIGHT,
	FORWARD,
	BACK
}

var facing_direction = directions.NONE
const maxVelocity = 100
const maxSkateVelocity = 300
const friction = 0.1
var cameraZoom 
var snapVector = Vector3.DOWN
var skating = false
signal lightToggle
func _ready():
	cameraZoom = $cameraRotation/Camera.fov
func _process(delta):
	rotation.y = lerp_angle(rotation.y,newRotation.y,0.1)
	$cameraRotation/Camera.fov = lerp($cameraRotation/Camera.fov,cameraZoom,0.1)
	if Input.is_action_pressed("jump"):
		if can_jump:
			velocity.y = jump_height
			snapVector = Vector3.ZERO
			can_jump = false
func _physics_process(delta):
	velocity.x = lerp(velocity.x,0,friction)
	velocity.z = lerp(velocity.z,0,friction)
	var cam_xForm = $cameraRotation/Camera.get_camera_transform()
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		cam_xForm.basis[0].y = 0
		direction += cam_xForm.basis[0]
		facing_direction = directions.LEFT
	elif Input.is_action_pressed("move_left"):
		cam_xForm.basis[0].y = 0
		direction -= cam_xForm.basis[0]
		facing_direction = directions.RIGHT
	if Input.is_action_pressed("move_forward"):
		cam_xForm.basis[2].y = 0
		direction -= cam_xForm.basis[2]
		facing_direction = directions.FORWARD
	elif Input.is_action_pressed("move_back"):
		cam_xForm.basis[2].y = 0
		direction += cam_xForm.basis[2]
		facing_direction = directions.BACK
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at((translation+$Pivot.translation)+direction,Vector3.UP)
	_process_sprites()
	if skating:
		velocity += (direction * skate_speed) * delta
		velocity.x = clamp(velocity.x,-maxSkateVelocity,maxSkateVelocity)
		velocity.z = clamp(velocity.z,-maxSkateVelocity,maxSkateVelocity)
		velocity.y -= fall_acceleration/2 * delta
		if is_on_floor():
			velocity.y = 0
			can_jump = true
		move_and_slide(velocity,Vector3.UP,true,4,deg2rad(35),false)
	else:
		velocity += (direction * speed) * delta
		velocity.x = clamp(velocity.x,-maxVelocity,maxVelocity)
		velocity.z = clamp(velocity.z,-maxVelocity,maxVelocity)
		velocity.y -= fall_acceleration * delta
		
		if is_on_floor():
			velocity.y = 0
			can_jump = true
			snapVector = Vector3.DOWN
		move_and_slide_with_snap(velocity,snapVector,Vector3.UP,true,4,deg2rad(65),false)
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)

func _input(event):
	if Input.is_action_just_pressed("skate"):
		if skating:
			skating = false
			$AnimationPlayer.play("Get_off_skate")
		else:
			skating = true
			$AnimationPlayer.play("Get_on_skate")
	if Input.is_action_just_pressed("flashlight_toggle"):
		emit_signal("lightToggle")
	if Input.is_action_just_pressed("rotate_camera_left"):
		rotation = newRotation
		newRotation.y = rotation.y + deg2rad(90)
	if Input.is_action_just_pressed("rotate_camera_right"):
		rotation = newRotation
		newRotation.y = rotation.y - deg2rad(90)
	if Input.is_action_just_pressed("zoom_in_camera"):
		cameraZoom = clamp(cameraZoom+10,60,140)
	if Input.is_action_just_pressed("zoom_out_camera"):
		cameraZoom = clamp(cameraZoom-10,60,140)
func _process_sprites():
	if facing_direction != directions.NONE:
		if facing_direction == directions.FORWARD:
			$Pivot/AnimatedSprite3D.play("Forward")
		if facing_direction == directions.BACK:
			$Pivot/AnimatedSprite3D.play("Back")
		if facing_direction == directions.LEFT:
			$Pivot/AnimatedSprite3D.play("Left")
		if facing_direction == directions.RIGHT:
			$Pivot/AnimatedSprite3D.play("Right")





func _on_interactionBubble_area_entered(area):
	if area.has_method("_interact"):
		area._interact()


func _on_interactionBubble_area_exited(area):
	if area.has_method("_interact"):
		area._interact()
