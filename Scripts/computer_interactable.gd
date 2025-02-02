extends Interactable

@onready var computer_screen = $Screen
@export var player: Player
@export var computer_camera: Camera3D
@onready var player_cam: Camera3D = player.get_node("Camera3D")





func _dialogic_parse(info: Dictionary):
	if info.variable == "Computer_On":
		if info.new_value == true:
			computer_screen.show()
		else:
			computer_screen.hide()
func interact():
	if pickable and not computer_screen.visible:
		Dialogic.start("computer")
		# add extra logic to move the player scene to the computer?
	elif pickable and computer_screen.visible:
		pickable = false
		computer_camera.make_current()
		await get_tree().create_timer(0.1).timeout
		player.stop_movement = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		player.stop_movement = false
		pickable = true
		player_cam.make_current()


func get_interact_text() -> String:
	if pickable and not computer_screen.visible:
		return "Press E to turn on"
	elif pickable and computer_screen.visible:
		return "Press E to interact"
	else:
		return "Press Q to quit."
