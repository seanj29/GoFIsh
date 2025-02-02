extends Interactable

@export var roaming_cam: Camera3D
@export var mob_timer: Timer
@export var player: Player
@export var fish_scene: PackedScene
@export var path_follows: Array[PathFollow3D]
@onready var spear: Node3D = roaming_cam.get_child(0)

var fish_count = 0
var turned_on = false

# @onready var spawn_loc: PathFollow3D = $Sketchfab_model/SpawnPath/SpawnLocation
# @onready var targ_location: PathFollow3D = $Sketchfab_model/SpawnPath/EndLocation

func _ready() -> void:
	mob_timer.connect("timeout", _on_mob_timer_timeout)

func _physics_process(delta: float) -> void:
	if fish_count > 0:
		for path in path_follows:
			if path.progress_ratio < 1.0:
				path.progress += 1.0 * delta
			else:
				path.progress_ratio = 0.0
				
func interact():
	if pickable:
		turned_on = true
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN 
		mob_timer.start(randf_range(1.0, 1.5))
		player.can_interact = false
		roaming_cam.make_current()
		spear.visible = true
		#animation player here.
		# add extra logic to move the player scene to the computer?
		pickable = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and turned_on:
		# var space_state := get_world_3d().direct_space_state
		var mousepos := get_viewport().get_mouse_position()
		var cam_origin := roaming_cam.project_ray_origin(mousepos)
		var looking_direction := (cam_origin + roaming_cam.project_ray_normal(mousepos) * 2)
		# var detectionParameters = PhysicsRayQueryParameters3D.new() 
		# detectionParameters.collide_with_areas = true
		# detectionParameters.from = cam_origin
		# detectionParameters.to = looking_direction
		spear.global_position = Vector3(looking_direction.x, spear.global_position.y, looking_direction.z)
		# var result := space_state.intersect_ray(detectionParameters)
		# if result:
		# 	print("Detected object: ", result.collider_id)
	if event.is_action_pressed("quit"):
		turned_on = false
		mob_timer.stop()
		roaming_cam.current = false
		spear.visible = false
		player.can_interact = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		pickable = true


func _on_mob_timer_timeout():

	if fish_count < 4:
		var random_path: PathFollow3D = path_follows.pick_random()
		random_path.progress_ratio = 0.0
		var fish = fish_scene.instantiate()
		fish_count += 1
		fish.tree_exiting.connect(func(): fish_count -= 1)
		random_path.add_child(fish)
		fish.init(random_path.global_position)




func get_interact_text() -> String:
	return "Press E to inspect"


		
