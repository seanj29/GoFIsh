extends CharacterBody3D
class_name Player

@export var Speed: float = 5.0
@export var Turn_Sens := 0.02
@export var ray_array: Array[RayCast3D]
@export var interaction_label: RichTextLabel
var reset_label: bool = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var in_dialogue = false
var can_interact = true

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("main")

func _on_timeline_started() -> void:
	in_dialogue = true
	can_interact = false

func _on_timeline_ended() -> void:
	in_dialogue = false
	await get_tree().create_timer(0.5).timeout
	can_interact = true

func _process(_delta: float) -> void:
	if ray_array.any(func(ray: RayCast3D) : return ray.is_colliding()) and can_interact:
		for ray in ray_array:
			if ray.is_colliding():
				var item := ray.get_collider()
				reset_label = true
				if item and item.get_parent().get_parent() is Interactable:
					var interact_parent: Interactable = item.get_parent().get_parent()
					interaction_label.text = interact_parent.get_interact_text()
	else:
		if reset_label:
			interaction_label.text = ""
			reset_label = false
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not in_dialogue:
		for ray in ray_array:
			if ray.is_colliding():
				var item := ray.get_collider()
				if item and item.get_parent().get_parent() is Interactable:
					var interact_parent: Interactable = item.get_parent().get_parent()
					interact_parent.interact()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta



	
	# Get the input direction and handle the movement/deceleration.
	if in_dialogue:
		return
	var forward_vec: float = Input.get_axis("up", "down")
	var direction_float: float = Input.get_axis("right", "left")
	
	var direction := Vector3.MODEL_FRONT.rotated(Vector3.UP,rotation.y) * forward_vec
	if direction and not direction_float:
		velocity = direction * Speed
	elif direction and direction_float:
		velocity = Vector3.ZERO
	else:
		velocity = Vector3.ZERO	
		rotate_y(direction_float * Turn_Sens)
	
	move_and_slide()
