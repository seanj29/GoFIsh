extends Interactable

@onready var computer_screen = $Screen

var is_on = false

func interact():
    if pickable and not is_on:
        is_on = true
        computer_screen.show()
        # add extra logic to move the player scene to the computer?
        print("Interacted with ", self)