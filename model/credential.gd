class_name Credential
extends Resource

## Credentials to be used for a [Poke].

## The name of the credential. If not set, only the type of the credential will be displayed.
@export
var name := ""

enum Type {
	NONE, ## No auth.
	BASIC, ## Base64-encoded basic auth.
	BEARER, ## Bearer token auth.
}
## The type of auth being used.
@export
var type := Type.NONE
## The current value of the credential. Might be encrypted if [member save_encrypted] is
## [code]true[/code] and the file was just loaded from disk.
@export
var value := ""

## Whether the [member value] should be encrypted/decrypted when saving/loading.
@export
var save_encrypted := false
## Path to the [CryptoKey] used for encryption/decryption.
@export
var crypto_key_path := ""
## Whether the [member value] is currently encrypted.
var is_encrypted := false

#-----------------------------------------------------------------------------#
# Builtin functions
#-----------------------------------------------------------------------------#

func _init() -> void:
	pass

#-----------------------------------------------------------------------------#
# Private functions
#-----------------------------------------------------------------------------#

func _load_crypto_key() -> CryptoKey:
	var key := CryptoKey.new()
	if key.load(crypto_key_path) != OK:
		return null
	
	return key

#-----------------------------------------------------------------------------#
# Public functions
#-----------------------------------------------------------------------------#

## Sets the auth to to [enum Type].NONE.
func set_none() -> void:
	type = Type.NONE
	value = ""

## Converts the [param username] and [param password] to a base64 encoded, basic-compliant value
## and sets the auth type to [enum Type].BASIC.
func set_basic(username: String, password: String) -> void:
	type = Type.BASIC
	value = Marshalls.utf8_to_base64("%s:%s" % [username, password])

## Stores the token and sets the auth type to [enum Type].BEARER token.
func set_bearer(token: String) -> void:
	type = Type.BEARER
	value = token

## Encrypts the current credential value. [br]
## [br]
## Returns [constant ERR_ALREADY_IN_USE] if the value is already encrypted. [br]
## Returns [constant ERR_FILE_NOT_FOUND] if the [member crypto_key_path] cannot be loaded. [br]
## Returns [constant OK] on success.
func encrypt() -> Error:
	if is_encrypted:
		return ERR_ALREADY_IN_USE
	
	var key := _load_crypto_key()
	if key == null:
		return ERR_FILE_NOT_FOUND
	
	value = Crypto.new().encrypt(key, value.to_utf8_buffer()).get_string_from_utf8()
	is_encrypted = true
	
	return OK

## Decrypts the current credential value. [br]
## [br]
## Returns [constant ERR_INVALID_DATA] if the value is already decrypted. [br]
## Returns [constant ERR_FILE_NOT_FOUND] if the [member crypto_key_path] cannot be loaded. [br]
## Returns [constant OK] on success.
func decrypt() -> Error:
	if not is_encrypted:
		return ERR_INVALID_DATA
	
	var key := _load_crypto_key()
	if key == null:
		return ERR_FILE_NOT_FOUND
	
	value = Crypto.new().decrypt(key, value.to_utf8_buffer()).get_string_from_utf8()
	is_encrypted = false
	
	return OK
