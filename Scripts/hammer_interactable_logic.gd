extends Interactable



func _dialogic_parse(info: Dictionary):
    if info.variable == "Has_Hammer":
        if info.new_value == true:
            queue_free()

func interact():
    if pickable:
        Dialogic.start("hammer")
