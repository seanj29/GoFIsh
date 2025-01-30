extends Node3D
class_name Interactable

@export var pickable = true

# Override this function to add custom interaction logic
func interact():
    if pickable:
        print("Interacted with ", self)