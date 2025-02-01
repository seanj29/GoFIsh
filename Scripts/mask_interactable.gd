extends Interactable

var inspected = false

# get a reference to if the hammer is in the inventory or not._about_to_close
# if it is, the player can use it the smash the mask?

func interact():
    if pickable:
        if not inspected:
            inspected = true
            Dialogic.start("mask")

        # Add logic here to make the player have be able to smash if has hammer..

func get_interact_text() -> String:
    if not inspected: 
        return "Press E to inspect"
    return "[s]Press E to inspect[/s]"