class_name Logger
extends RefCounted

const Level := {
	INFO = "INFO",
	WARNING = "WARNING",
	ERROR = "ERROR",
	
	DEBUG = "DEBUG",
	GLOBAL = "GLOBAL",
}

var name: StringName = "DefaultLogger"

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init(p_name: StringName) -> void:
	name = p_name

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

static func _log(level: StringName, id: StringName, message: String) -> void:
	var time := Time.get_datetime_dict_from_system()
	
	message = "[%s] %s-%s-%s %s:%s:%s %s: %s" % [
		level,
		time.year, time.month, time.day,
		time.hour, time.minute, time.second,
		id,
		message
	]
	
	print(message)
	LogStore.add_log(message)

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func info(message: String) -> void:
	_log(Level.INFO, name, message)

func warning(message: String) -> void:
	_log(Level.WARNING, name, message)

func error(message: String) -> void:
	_log(Level.ERROR, name, message)

func debug(message: String) -> void:
	if OS.is_debug_build():
		_log(Level.DEBUG, name, message)

static func global(id: StringName, message: String) -> void:
	_log(Level.GLOBAL, id, message)

static func nyi() -> void:
	var stack := get_stack()
	if stack.size() < 2:
		return
	stack.pop_front()
	
	var frame: Dictionary = stack.front()
	
	print("[NYI] Function %s is not implemented in file %s:%d" % [
		frame.function, frame.source, frame.line
	])
