@tool
class_name UUID_Component extends Node

@export var uuid:String = str(ResourceUID.create_id())

@export_tool_button("make new")
var setter = set_uuid

func set_uuid()->void:
	uuid = str(ResourceUID.create_id())
