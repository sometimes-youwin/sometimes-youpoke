class_name Toolbox
extends Resource

## A collection of resources necessary for poking APIs.
##
## A collection of resources necessary for poking APIs. Toolboxes can be collected
## together into a [Project].

## The name of the toolbox.
@export
var name := ""
## The pokes owned by the toolbox.
@export
var pokes: Array[Poke] = []
## The credentials owned by the toolbox.
@export
var credentials: Array[Credential] = []
## Static variables that can be used in [Poke]s. The key indicates the [String] to be replaced.
## The value is the replacement String.
@export
var variables := {}
## Dynamic variables that can be used in [Poke]s. The key indicates the [String] to be replaced.
## The value is a [CalculatedVariable] that will have its [method CalculatedVariable.calculate]
## method called.
@export
var calculated_variables := {}
## Tests to be run before each [Poke].
@export
var pre_tests: Array[PokeTest] = []
## Tests to be run after each [Poke].
@export
var post_tests: Array[PokeTest] = []

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

func copy_toolbox() -> Toolbox:
	var tb := Toolbox.new()
	
	tb.name = self.name
	tb.pokes = self.pokes.duplicate(true)
	tb.credentials = self.credentials.duplicate(true)
	tb.variables = self.variables.duplicate(true)
	tb.calculated_variables = self.calculated_variables.duplicate(true)
	tb.pre_tests = self.pre_tests.duplicate(true)
	tb.post_tests = self.post_tests.duplicate(true)
	
	return tb
