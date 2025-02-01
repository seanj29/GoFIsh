extends Interactable

@export var roaming_cam: Camera3D
@export var mob_timer: Timer
@export var player: Player
@export var fish_scene: PackedScene
@export var path_follows: Array[PathFollow3D]
var fish_count = 0

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

		mob_timer.start(randf_range(0.1, 1))
		player.can_interact = false
		if not roaming_cam.is_current():
			roaming_cam.set_current(true)
		else:
			roaming_cam.set_current(false)
		#animation player here.
		# add extra logic to move the player scene to the computer?
		print("Interacted with ", self)
		pickable = false

func _on_mob_timer_timeout():

	if fish_count < 4:
		var random_path: PathFollow3D = path_follows.pick_random()
		random_path.progress_ratio = 0.0
		var fish = fish_scene.instantiate()
		fish_count += 1
		fish.queued_for_deletion.connect(func(): fish_count -= 1)
		random_path.add_child(fish)
		fish.init(random_path.global_position)




func get_interact_text() -> String:
	return "Press E to fish"


		
