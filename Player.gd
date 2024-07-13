extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_map:Array[int] = [0,1,1]
var move_up:int = 0
var move_down:int = 0
var move_left:int = 0
var move_right:int = 0

func _input(event: InputEvent) -> void:
  if event.is_action_pressed('move_up'):
    move_up += move_down + 1
  if event.is_action_released('move_up'):
    move_up = 0
    move_down = movement_map[move_down]
  if event.is_action_pressed('move_down'):
    move_down += move_up + 1
  if event.is_action_released('move_down'):
    move_down = 0
    move_up = movement_map[move_up]
  if event.is_action_pressed('move_left'):
    move_left += move_right + 1
  if event.is_action_released('move_left'):
    move_left = 0
    move_right = movement_map[move_right]
  if event.is_action_pressed('move_right'):
    move_right += move_left + 1
  if event.is_action_released('move_right'):
    move_right = 0
    move_left = movement_map[move_left]

func _physics_process(delta: float) -> void:
  # Add the gravity.
  if not is_on_floor():
    velocity.y -= gravity * delta

  # Handle jump.
  if Input.is_action_just_pressed("ui_accept") and is_on_floor():
    velocity.y = JUMP_VELOCITY

  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.
  # var input_dir:Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  var input_dir:Vector2 = Vector2(move_up - move_down, move_right - move_left)
  var direction:Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
  if direction:
    velocity.x = direction.x * SPEED
    velocity.z = direction.z * SPEED
  else:
    velocity.x = move_toward(velocity.x, 0, SPEED)
    velocity.z = move_toward(velocity.z, 0, SPEED)

  move_and_slide()
