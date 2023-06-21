class_name Project
extends Toolbox

## A collection of [Toolbox]es for a specific task.
##
## A collection of [Toolbox]es. If another Project is added to this project,
## the other [Project]'s toolboxes will be flattened into this project.

## The [Toolbox]es current owned by the project.
@export
var toolboxes: Array[Toolbox] = []

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _has_toolbox(other: Toolbox) -> bool:
	return toolboxes.any(func(v: Toolbox) -> bool:
		return v.name == other.name
	)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Add a [Toolbox] to the current project. If another [Project] is passed, the
## toolboxes from the other project will be appended to the current [member toolboxes]. [br]
##
## [Toolbox]es with duplicate names are automatically skipped.
func add_toolbox(item: Toolbox) -> void:
	if item is Project:
		for tb in item.toolboxes:
			if _has_toolbox(tb):
				continue
			toolboxes.append(tb)
		if not _has_toolbox(item):
			toolboxes.append(item.copy_toolbox())
	else:
		toolboxes.append(item)
