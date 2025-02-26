extends Interactable

@export var well_cam: Camera3D
@export var mob_timer: Timer
@export var player: Player
@export var fish_scene: PackedScene
@export var path_follows: Array[PathFollow3D]
@onready var spear: Node3D = well_cam.get_node("Spear")
@onready var ray_cast: RayCast3D = spear.get_node("RayCast3D")
@onready var audio: AudioStreamPlayer3D = spear.get_node("AudioStreamPlayer3D")
@onready var player_cam: Camera3D = player.get_node("Camera3D")

var fish_count = 0
var turned_on = false
var spear_piercing = false
var spear_wanted_pos: Vector3

func _ready() -> void:
    super()
    mob_timer.timeout.connect( _on_mob_timer_timeout)


func _physics_process(delta: float) -> void:
    if fish_count > 0:
        for path in path_follows:
            if path.progress_ratio < 1.0:
                path.progress += 1.0 * delta
            else:
                path.progress_ratio = 0.0
    
    if not spear_piercing and spear_wanted_pos and not is_zero_approx(spear_wanted_pos.distance_squared_to(spear.global_position)):
        spear.global_position = spear.global_position.lerp(spear_wanted_pos, delta * 10)




func _dialogic_parse(info: Dictionary):
    if info.variable == "Fishing":
        if info.new_value == true:
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
    if event is InputEventMouseMotion and turned_on and not spear_piercing:
        var mousepos := (event as InputEventMouseMotion).position
        var cam_origin := well_cam.project_ray_origin(mousepos)
        var looking_direction := (cam_origin + well_cam.project_ray_normal(mousepos) * 2)
        spear_wanted_pos = Vector3(looking_direction.x, spear.global_position.y, looking_direction.z)

    if event is InputEventMouseButton and turned_on and not spear_piercing:
        var mouse_event = event as InputEventMouseButton
        if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
            _spear_pierce_anim()
            await get_tree().create_timer(0.4).timeout
            if ray_cast.is_colliding():
                var collision: Area3D = ray_cast.get_collider()
                if collision.get_parent().get_parent() is Fish:
                    var fish: Fish = collision.get_parent().get_parent()
                    fish.caught()
                    quit()


                    
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

func _spear_pierce_anim():
    spear_piercing = true
    var tween = create_tween()
    audio.play()
    tween.tween_property(spear, "global_position:y", -1.0, 0.25).as_relative().set_trans(Tween.TRANS_EXPO)
    tween.tween_interval(0.2)
    tween.tween_property(spear, "global_position:y", 1.0, 0.5).as_relative().set_trans(Tween.TRANS_SINE)
    if not tween.finished.is_connected(func (): spear_piercing = false):
        tween.finished.connect(func (): spear_piercing = false)


func get_interact_text() -> String:
    if pickable:
        return "Press E to inspect"
    else:
        return "Press Q to stop fishing."


        
func quit():
        turned_on = false
        mob_timer.stop()
        player_cam.make_current()
        spear.visible = false
        ray_cast.enabled = false
        player.stop_movement = false
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        pickable = true