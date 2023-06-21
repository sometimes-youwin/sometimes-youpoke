class_name Poke
extends Resource

## Data associated with poking an api.

## The name for the poke. If not set, the url will be used instead.
@export
var name := ""

enum Type {
	NONE, ## A new poke that cannot do anything.
	HTTP, ## Poke using an HTTP verb.
	WEBSOCKET, ## Poke a websocket.
}
## The type of poke this data represents.
@export
var type := Type.NONE

## The url this poke is targeting.
@export
var url := ""
## The headers to use for requests.
@export
var headers: Array[String] = []
## The credential to use for requests.
@export
var credential := Credential.new()

@export
var pre_test: PokeTest = null
@export
var post_test: PokeTest = null

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#
