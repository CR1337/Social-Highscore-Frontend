extends Node

func trigger():
	get_node("parent").trigger()
