extends Node

var items := ["nut", "bread", "aid", "beer", "wrench", "hammer"]



func give_sequential() -> String:
    if items:
        var item = items.pop_front()
        return item
    else:
        return ""

func return_to_pool(item: String) -> void:
    items.push_front(item)