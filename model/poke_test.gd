class_name PokeTest
extends Resource

@export
var is_self_contained := true
@export
var code := ""

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

static func _self_contain(text: String) -> String:
	var new_text := ""
	for line in text.split("\n"):
		new_text += "\t%s\n" % line
	
	return """
extends Object

func __default__(response: String) -> Variant:
%s
	return true
	""".strip_edges() % new_text

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Runs the test given some output from a [Poke]. [br]
## Returns [constant OK] on success. [br]
## Returns a [StringName] message on error.
func run(poke_output: String) -> Variant:
	if code.is_empty():
		return &"No test code available to run."
	
	var test_script := GDScript.new()
	test_script.source_code = code if is_self_contained else _self_contain(code)
	
	var err := test_script.reload()
	if err != OK:
		return &"Failed to compile test script because of error %d." % err
	
	var tests := PackedStringArray()
	for d in test_script.get_script_method_list():
		var test_name: String = d.get("name", "")
		var args_size: int = d.get("args", []).size()
		
		if test_name.is_empty():
			return &"Test is missing a name. This is most likely a bug."
		if args_size != 1:
			return &"Test \"%s\" is required to take 1 arg but can only take %s args." % [
				test_name, args_size
			]
		else:
			var arg_type: int = d.args.front().get("type", 0)
			if arg_type != TYPE_NIL and arg_type != TYPE_STRING and arg_type != TYPE_STRING_NAME:
				return &"Test \"%s\" must take a String as an argument." % test_name
		
		tests.append(test_name)
	
	var test_instance: Object = test_script.new()
	
	var failed_tests := PackedStringArray()
	for test in tests:
		var test_result: Variant = test_instance.call(test, poke_output)
		match typeof(test_result):
			TYPE_NIL:
				# Explicitly do nothing. Everything else that isn't handled is treated as a failure.
				pass
			TYPE_BOOL:
				if test_result == false:
					failed_tests.append("Test %s failed." % test)
			TYPE_INT:
				if test_result != OK:
					failed_tests.append("Test %s failed: %d" % [test, test_result])
			TYPE_STRING, TYPE_STRING_NAME:
				failed_tests.append("Test %s failed: %s" % [test, test_result])
			_:
				failed_tests.append("Test %s failed: %s" % [test, str(test_result)])
	
	if failed_tests.size() > 0:
		return &"The following tests failed: %s" % str(failed_tests)
	
	if not test_instance is RefCounted:
		test_instance.free()
	
	return OK
