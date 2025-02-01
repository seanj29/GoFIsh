extends Node3D
class_name Interactable

@export var pickable = true
signal return_control

# Override this function to add custom interaction logic
func interact():
    if pickable:
        print("Interacted with ", self)

func get_interact_text() -> String:
    return "Press E to inspect"