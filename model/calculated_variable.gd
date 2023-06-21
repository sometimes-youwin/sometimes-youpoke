class_name CalculatedVariable
extends Resource

## Variables required to calculate this variable.
@export
var required_variables: Array[String] = []
## The code that is run to calculate the variable.
@export
var code := ""

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Calculates the variable. [br]
## Returns a [String] if calculation occurred successfully. [br]
## Returns a [StringName] message if an error occurred.
func calculate(inputs: Array) -> Variant:
	if inputs.size() != required_variables.size():
		return ""
	var params := ""
	for i in required_variables:
		params = "%s%s," % [params, i]
	
	var new_code := ""
	for i in code.split("\n"):
		new_code += "\t%s\n" % i
	
	var gdscript := GDScript.new()
	gdscript.source_code = """
extends Object

func run(%s) -> String:
%s
	return ""
	""".strip_edges() % [params, new_code]
	
	if gdscript.reload() != OK:
		return ""
	
	var instance: Object = gdscript.new()
	var value: String = instance.callv("run", inputs)
	instance.free()
	
	return value
