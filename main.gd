extends Node

## Entrypoint to the app. Shim to allow initial resources to cache.
## No actual app logic should be run here.

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	ResourceLoader.load("res://assets/main.theme")
	
	get_tree().change_scene_to_packed(preload("res://screens/home/home.tscn"))

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
