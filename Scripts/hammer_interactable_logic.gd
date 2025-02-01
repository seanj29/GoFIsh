extends Interactable

var inspected = false

func interact():
    if pickable:
        if not inspected:
            inspected = true
            Dialogic.start("hammer")
        else:
            print("Picked up ", self)
            # Add logic here to make the player have the item in invertory or something.
            queue_free()

func get_interact_text() -> String:
    if not inspected: 
        return "Press E to inspect"
    return "Press E to pick up"