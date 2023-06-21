extends Node

const LOG_FILE_FORMAT := "user://SometimesYoupoke_%s.log"
const MAX_LOGS: int = 1000
const MAX_LOG_FILES: int = 4

var _timestamp := "invalid"
var _logs: Array[String] = []

var _logger := Logger.new("LogStore")

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _ready() -> void:
	if _rotate_logs() != OK:
		_logger.error("Unable to rotate logs")
	
	var time := Time.get_datetime_dict_from_system()
	_timestamp = "%s-%s-%s_%s-%s-%s" % [
		time.year, time.month, time.day,
		time.hour, time.minute, time.second
	]
	FileAccess.open(LOG_FILE_FORMAT % _timestamp, FileAccess.WRITE)

func _exit_tree() -> void:
	flush()

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _rotate_logs() -> Error:
	_logger.debug("Rotating logs")
	
	var dir := DirAccess.open("user://")
	if dir == null:
		return DirAccess.get_open_error()
	
	dir.list_dir_begin()
	
	var log_count: int = 0
	var oldest_file := ""
	var oldest_modified_time: int = -1
	
	var file := dir.get_next()
	while not file.is_empty():
		if dir.current_is_dir():
			file = dir.get_next()
			continue
		if file.get_extension().to_lower() != "log":
			file = dir.get_next()
			continue
		
		log_count += 1
		
		var file_path := "user://%s" % file
		
		var modified_time := FileAccess.get_modified_time(file_path)
		if oldest_modified_time < 0 or modified_time < oldest_modified_time:
			oldest_modified_time = modified_time
			oldest_file = file_path
		
		file = dir.get_next()
	
	if log_count > MAX_LOG_FILES:
		_logger.debug("Removing old log file at %s" % oldest_file)
		
		var err := DirAccess.remove_absolute(oldest_file)
		if err != OK:
			_logger.error("Unable to delete log file at %s because of error %d" % [oldest_file, err])
			return err
		
		_logger.debug("Successfully removed old log file at %s" % oldest_file)
	
	return OK

func _open_log_file() -> FileAccess:
	var file := FileAccess.open(LOG_FILE_FORMAT % _timestamp, FileAccess.READ_WRITE)
	if file == null:
		_logger.error("Unable to open log file at %s" % LOG_FILE_FORMAT % _timestamp)
		return null
	
	file.seek_end()
	
	return file

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Write all logs to disk and clear all logs in memory.
func flush() -> Error:
	_logger.debug("Flushing logs")
	
	var file := _open_log_file()
	if file == null:
		_logger.error("Unable to flush logs")
		return ERR_FILE_CANT_WRITE
	
	for line in _logs:
		file.store_line(line)
	
	_logs.clear()
	
	_logger.debug("Flush successful")
	
	return OK

func get_logs(in_memory_only: bool = false) -> PackedStringArray:
	var r := PackedStringArray(_logs)
	if in_memory_only:
		return r
	
	var file := _open_log_file()
	if file == null:
		_logger.error("Unable to get logs from file")
		return r
	
	var file_lines: PackedStringArray = file.get_as_text().split("\n")
	# Append in reverse here since the in-memory logs are later than the logs on disk
	file_lines.append_array(r)
	
	return file_lines

func add_log(message: String) -> void:
	_logs.append(message)
	
	if _logs.size() > MAX_LOGS:
		flush()
