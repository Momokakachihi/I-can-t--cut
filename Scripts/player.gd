extends Node2D
@export var speed = 400
@export var dash_speed = 1200
@export var dash_distance = 200.0
var dash_cooldown: float = 2
var dash_cooldown_left: float = 0
var dash_time_left: float = 0
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var dash_duration: float

# Called when the node enters the scene tree for the first time.
func _ready():
	if dash_distance == null or dash_speed == null or dash_speed == 0:
		dash_duration = 0.2  # fallback value
	else:
		dash_duration = dash_distance / dash_speed

func _process(_delta: float) -> void:
	DoDash(_delta)

func DoMove(_delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * _delta

func DoDash(_delta: float) -> void:
	if dash_cooldown_left > 0:
		dash_cooldown_left -= _delta

	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if not is_dashing and dash_cooldown_left <= 0 and Input.is_action_just_pressed("dash"):
		if velocity.length() > 0:
			is_dashing = true
			dash_time_left = dash_duration
			dash_direction = velocity.normalized()
			dash_cooldown_left = dash_cooldown

	if is_dashing:
		position += dash_direction * dash_speed * _delta
		dash_time_left -= _delta
		if dash_time_left <= 0:
			is_dashing = false
	else:
		DoMove(_delta)
	
