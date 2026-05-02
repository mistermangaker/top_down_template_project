extends Area2D
class_name InteractableDetector

var interactables: Array[InteractableObject] = []
var closest:InteractableObject
signal new_closest_detected(object:InteractableObject)
signal no_closest_detected

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func reset_and_rescan()->void:
	closest = null
	sort_closest()

func _on_body_entered(body: Node2D) -> void:
	if body is InteractableObject:
		interactables.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body is InteractableObject:
		interactables.erase(body)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	sort_closest()

func set_closest(i:InteractableObject)->void:
	if closest == i:
		return
	closest = i
	if closest == null:
		no_closest_detected.emit()
	else:
		new_closest_detected.emit(closest)

func sort_closest()->void:
	if interactables.size() == 0:
		set_closest(null)
		return
	elif interactables.size()==1:
		if interactables[0].should_be_visible():
			set_closest(interactables[0])
		else:
			set_closest(null)
		return
	
	var temp_closest:InteractableObject = interactables[0]
	
	for i in interactables:
		if !i.should_be_visible():
			continue
		if global_position.distance_to(i.global_position) < global_position.distance_to(temp_closest.global_position):
			temp_closest = i
	
	if temp_closest.should_be_visible():
		set_closest(temp_closest)
	else:
		set_closest(null)
	
