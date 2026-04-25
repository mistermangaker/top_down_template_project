extends InteractableObject
@export var thing_to_print_out:String = "this is some test text"

func _do_interaction_internal()->void:
	print(thing_to_print_out)
