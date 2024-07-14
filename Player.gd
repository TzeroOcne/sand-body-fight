extends CharacterBody3D

class_name Player

@export var sprite:Sprite3D
@export var animator:AnimationPlayer
@export var air_speed: float = 1.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_map:Array[int] = [0,1,1]
var move_up:int = 0
var move_down:int = 0
var move_left:int = 0
var move_right:int = 0

func is_moving() -> bool:
  return move_up + move_down + move_left + move_right > 0

func get_ground_dir() -> Vector2:
  return Vector2(move_up - move_down, move_right - move_left)

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('move_up'):
    move_up = min(2, move_down + 1)
  if event.is_action_pressed('move_down'):
    move_down = min(2, move_up + 1)
  if event.is_action_pressed('move_left'):
    move_left = min(2, move_right + 1)
  if event.is_action_pressed('move_right'):
    move_right = min(2, move_left + 1)
  if event.is_action_pressed('attack'):
    animator.play('rotate')

func speed_multiplier() -> float:
  return air_speed

func process_not_pressed_key() -> void:
  if !Input.is_action_pressed('move_up'):
    move_up = 0
    move_down = movement_map[move_down]
  if !Input.is_action_pressed('move_down'):
    move_down = 0
    move_up = movement_map[move_up]
  if !Input.is_action_pressed('move_left'):
    move_left = 0
    move_right = movement_map[move_right]
  if !Input.is_action_pressed('move_right'):
    move_right = 0
    move_left = movement_map[move_left]

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if is_on_floor():
    process_not_pressed_key()
    air_speed = 1
  else:
    air_speed = 0.8
    velocity.y -= gravity * delta

  # Handle jump.
  if Input.is_action_pressed('move_jump') and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  # var input_dir:Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  var input_dir:Vector2 = get_ground_dir()

  # Animate sprite
  if is_moving() && is_on_floor():
    sprite.transform = sprite.transform.looking_at(sprite.position + Vector3(input_dir.x, 0, input_dir.y))

  var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED * speed_multiplier()
    velocity.z = direction.z * SPEED * speed_multiplier()
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()
