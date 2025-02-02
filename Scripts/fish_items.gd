extends Node

var items := ["a nut", "some bread", "a first aid kit", "a bottle", "a wrench", "a hammer"]

signal item_found(item: String)

var last_caught: String = ""

func _ready() -> void: 
    item_found.connect(set_last_caught)

func give_sequential() -> String:
    if items:
        var item = items.pop_front()
        return item
    else:
        return ""

func return_to_pool(item: String) -> void:
    items.push_front(item)


func set_last_caught(item: String):
    last_caught = item