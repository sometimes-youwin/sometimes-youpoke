extends Node

var _logger := Logger.new("AppManager")

var _recent_projects: Array[Project] = []
var _recent_toolboxes: Array[Toolbox] = []

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	var metadata := Metadata.load()
	# Don't bail out during any of these errors. These are all recoverable
	if metadata.scan() != OK:
		_logger.error("Unable to scan for metadata")
	if metadata.save() != OK:
		_logger.error("Unable to save metadata at path %s" \
			% ProjectSettings.globalize_path(Metadata.METADATA_PATH))
	
	for i in metadata.recent_projects:
		var res: Project = load(i)
		if res == null or not res is Project:
			_logger.error("Unable to load project from path %s" % i)
			continue
		_recent_projects.append(res)
	for i in metadata.recent_toolboxes:
		var res: Toolbox = load(i)
		if res == null or not res is Toolbox:
			_logger.error("Unable to load toolbox from path %s" % i)
			continue
		_recent_toolboxes.append(res)
	
	_logger.debug("AppManager ready")

func _exit_tree() -> void:
	var metadata := Metadata.load()
	
	metadata.recent_projects.clear()
	for i in _recent_projects:
		metadata.recent_projects.append(i.resource_path)
	
	metadata.recent_toolboxes.clear()
	for i in _recent_toolboxes:
		metadata.recent_toolboxes.append(i.resource_path)
	
	metadata.save()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
