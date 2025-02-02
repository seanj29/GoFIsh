extends Node3D
@export var hammer: Node3D
@export var wrench: Node3D
@export var aid: Node3D
@export var glass: Node3D
@export var nut: Node3D
@export var bread: Node3D

func _ready() -> void:
    FishItems.item_found.connect(make_item_visible)



func make_item_visible(item: String):
    match item:
        "a nut":
            nut.visible = true
        "some bread":
            bread.visible = true
        "a first aid kit":
            aid.visible = true
        "a bottle":
            glass.visible = true
        "a wrench":
            wrench.visible = true
        "a hammer":
            hammer.visible = true