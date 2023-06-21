class_name Metadata
extends Resource

## Metadata about the app that is not held in memory.
##
## Metadata has data about app files. The class is not stored in memory
## and is instead loaded whenever it is needed.

const METADATA_PATH := "user://__metadata__.tres"

## Known paths to [Project]s.
@export
var projects := {}
## Known paths to [Toolbox]es.
@export
var toolboxes := {}

## Recent [Project]s from the last session.
@export
var recent_projects: Array[String] = []
## Recent [Toolbox]es from the last session.
@export
var recent_toolboxes: Array[String] = []

var _logger := Logger.new("Metadata")

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

static func load() -> Metadata:
	var res: Metadata = ResourceLoader.load(METADATA_PATH)
	if res == null:
		res = Metadata.new()
		ResourceSaver.save(res, METADATA_PATH)
	
	return res

func save() -> Error:
	return ResourceSaver.save(self, METADATA_PATH)

## Scan for metadata in the user data directory. This method is extremely expensive, as it
## goes through and loads, checks, and classifies every valid resource file.
func scan() -> Error:
	var user_data_dir := ProjectSettings.globalize_path("user://")
	var dir := DirAccess.open(user_data_dir)
	if dir == null:
		_logger.error("Unable to open user data directory %s" % user_data_dir)
		return ERR_CANT_OPEN
	
	dir.include_hidden = false
	dir.include_navigational = false
	
	dir.list_dir_begin()
	
	var known_resources := PackedStringArray()
	
	var file := dir.get_next()
	while not file.is_empty():
		if dir.current_is_dir():
			file = dir.get_next()
			continue
		if file.get_extension().to_lower() != "tres":
			file = dir.get_next()
			continue
		
		known_resources.append("%s/%s" % [user_data_dir, file])
		
		file = dir.get_next()
	
	for i in known_resources:
		var res = load(i)
		if res == null:
			_logger.error("Unable to load resource %s" % i)
			continue
		
		if res is Project:
			projects[res.name] = i
		elif res is Toolbox:
			toolboxes[res.name] = i
		elif res is Metadata:
			continue
		else:
			_logger.error("Found unknown resource %s" % str(res))
	
	return OK
