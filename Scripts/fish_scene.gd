extends Node3D
class_name Fish

@onready var light: OmniLight3D = $fish_mx_1/OmniLight3D
# Minimum speed of the fish in meters per second.
# @export var min_speed = 1
# # Maximum speed of the fish in meters per second.
# @export var max_speed = 3

# var velocity: Vector3 = Vector3()

# func _physics_process(delta: float) -> void:
#     position += velocity * delta

    

func init(start_pos: Vector3) -> void:
   global_position = start_pos
   var life_timer = get_tree().create_timer(randf_range(1,5))
   life_timer.timeout.connect(_on_life_timer_timeout)

    # look_at_from_position(start_pos, target_position, Vector3.UP, true)
    # rotate_y(randf_range(-PI / 4, PI / 4))

    # var random_speed = randi_range(min_speed, max_speed)
    # velocity = Vector3.FORWARD * random_speed
    # velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_life_timer_timeout() -> void:
    queue_free()



