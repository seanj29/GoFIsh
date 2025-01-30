extends CharacterBody3D

@export var Speed: float = 5.0
@export var Turn_Sens := 0.02
@export var ray_array: Array[RayCast3D]
@export var interaction_label: Label
var label_reset: bool = true
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(_delta: float) -> void:
	if ray_array.any(func(ray: RayCast3D) : return ray.is_colliding()):
		for ray in ray_array:
			if ray.is_colliding():
				var item := ray.get_collider()
				label_reset = false
				if item and item.get_parent().get_parent() is Interactable:
					interaction_label.text = "Press E to interact"
	else:
		if not label_reset:
			interaction_label.text = ""
			label_reset = true
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
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
	# As good practice, you should replace UI actions with custom gameplay actions.
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

