extends CanvasLayer

const HomeOptions := preload("res://screens/home/home_options.gd")

@onready
var _home_options := %HomeOptions

var _logger := Logger.new("Home")

var _current_project := Project.new()

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	_logger.debug("Setting up")
	
	_home_options.option_selected.connect(func(item: StringName) -> void:
		match item:
			HomeOptions.AppOptions.SETTINGS:
				pass
			HomeOptions.AppOptions.ABOUT:
				pass
			HomeOptions.AppOptions.QUIT:
				get_tree().quit()
			HomeOptions.ProjectOptions.NEW:
				pass
			HomeOptions.ProjectOptions.OPEN:
				pass
			HomeOptions.ProjectOptions.OPEN_RECENT:
				pass # Intentionally unused
			
			HomeOptions.ToolboxOptions.ADD:
				pass
			HomeOptions.ToolboxOptions.IMPORT:
				pass
			HomeOptions.ToolboxOptions.IMPORT_RECENT:
				pass # Intentionally unused
			
			HomeOptions.PokeOptions.NEW:
				pass
			HomeOptions.PokeOptions.CLONE:
				pass
			_:
				_logger.error("Unhandled option %s" % item)
	)
	
	_logger.debug("Finished setting up")

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

