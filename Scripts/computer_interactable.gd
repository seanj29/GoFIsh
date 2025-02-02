extends Interactable

@onready var computer_screen = $Screen



func _dialogic_parse(info: Dictionary):
	if info.variable == "Computer_On":
		if info.new_value == true:
			computer_screen.show()
		else:
			computer_screen.hide()
func interact():
	if pickable:
		Dialogic.start("computer")
		# add extra logic to move the player scene to the computer?


func get_interact_text() -> String:
	if pickable:
		return "Press E to inspect"
	else:
		return "Press Q to quit out."