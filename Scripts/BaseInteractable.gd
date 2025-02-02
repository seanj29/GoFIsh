extends Node3D
class_name Interactable

@export var pickable = true

func _ready() -> void:
    pickable = visible
    visibility_changed.connect(func (): pickable = visible)
    Dialogic.VAR.variable_changed.connect(_dialogic_parse)

func _dialogic_parse(_info: Dictionary):
    pass

# Override this function to add custom interaction logic
func interact():
    if pickable:
        print("Interacted with ", self)

func get_interact_text() -> String:
    if pickable:
        return "Press E to inspect"
    else:
        return ""