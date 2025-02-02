extends Interactable

@export var well_cam: Camera3D
@export var mob_timer: Timer
@export var player: Player
@export var fish_scene: PackedScene
@export var path_follows: Array[PathFollow3D]
@onready var spear: Node3D = well_cam.get_node("Spear")
@onready var ray_cast: RayCast3D = spear.get_node("RayCast3D")
@onready var player_cam: Camera3D = player.get_node("Camera3D")

var fish_count = 0
var turned_on = false



func _physics_process(delta: float) -> void:
    if fish_count > 0:
        for path in path_follows:
            if path.progress_ratio < 1.0:
                path.progress += 1.0 * delta
            else:
                path.progress_ratio = 0.0


func _dialogic_parse(info: Dictionary):
    if info.variable == "Fishing":
        if info.new_value == true:
            mob_timer.timeout.connect( _on_mob_timer_timeout)
            turned_on = true
            Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN 
            mob_timer.start(randf_range(1.0, 1.5))
            well_cam.make_current()
            spear.visible = true
            ray_cast.enabled = true
            pickable = false
            await get_tree().create_timer(0.1).timeout
            player.stop_movement = true
        else:
            return


func interact():

    if pickable:
        Dialogic.start("well")
        

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and turned_on:
        # var space_state := get_world_3d().direct_space_state
        var mousepos := get_viewport().get_mouse_position()
        var cam_origin := well_cam.project_ray_origin(mousepos)
        var looking_direction := (cam_origin + well_cam.project_ray_normal(mousepos) * 2)
        # var detectionParameters = PhysicsRayQueryParameters3D.new() 
        # detectionParameters.collide_with_areas = true
        # detectionParameters.from = cam_origin
        # detectionParameters.to = looking_direction
        spear.global_position = Vector3(looking_direction.x, spear.global_position.y, looking_direction.z)
        # var result := space_state.intersect_ray(detectionParameters)
        # if result:
        # 	print("Detected object: ", result.collider_id)
    if event is InputEventMouseButton and turned_on:
        var mouse_event = event as InputEventMouseButton
        if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
            _animate_spear()
            if ray_cast.is_colliding():
                var collision: Area3D = ray_cast.get_collider()
                if collision.get_parent().get_parent() is Fish:
                    var fish: Fish = collision.get_parent().get_parent()
                    quit()
                    fish.caught()

                    
    if event.is_action_pressed("quit"):
        quit()


func _on_mob_timer_timeout():

    if fish_count < 4:
        var random_path: PathFollow3D = path_follows.pick_random()
        random_path.progress_ratio = 0.0
        var fish = fish_scene.instantiate()
        fish_count += 1
        fish.tree_exiting.connect(func(): fish_count -= 1)
        random_path.add_child(fish)
        fish.init(random_path.global_position)

func _animate_spear():
    var tween = get_tree().create_tween()
    tween.tween_property(spear, "global_position:y", -1.0, 0.25).as_relative().set_trans(Tween.TRANS_EXPO)
    tween.tween_interval(0.2)
    tween.tween_property(spear, "global_position:y", 1.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)


func get_interact_text() -> String:
    if pickable:
        return "Press E to inspect"
    else:
        return "Press Q to stop fishing."


        
func quit():
        turned_on = false
        mob_timer.stop()
        mob_timer.timeout.disconnect(_on_mob_timer_timeout)
        player_cam.make_current()
        spear.visible = false
        ray_cast.enabled = false
        player.stop_movement = false
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        pickable = true