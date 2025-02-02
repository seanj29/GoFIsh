extends Interactable


# get a reference to if the hammer is in the inventory or not._about_to_close
# if it is, the player can use it the smash the mask?

func _ready() -> void:
    Dialogic.VAR.variable_changed.connect(_dialogic_parse)

func _dialogic_parse(info: Dictionary):
    if info.variable == "Has_Mask":
        if info.new_value == true:
            queue_free()
    if info.variable == "Mask_Smashed":
        if info.new_value == true:
            queue_free()

func interact():
    if pickable:
            Dialogic.start("mask")

        # Add logic here to make the player have be able to smash if has hammer..