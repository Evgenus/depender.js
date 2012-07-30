depender.js
===========

_Tiny simplified load-order resolver for JS._

Helps you to divide coffee-script sources before `--join` into separate parts and runs them in valid order. 

 - No dependency resolving. 
 - No automatic-script-tag-creation.
 - No XHR.
 - Not a package manager.

### Api

`namespace("string-dot-separated-path")` - requests or creates namespace for given path. Namespace parts are simply objects.

`define(["string-dot-separated-path", "string-dot-separated-path", ...], callback-function)` - run callback when all paths can be resolved.

### Usage in coffescript

`m1.coffee`

	define [
		"mypackage.module_2.A"
	], ->
		console.log("run it as #2")

		module_2 = namespace "mypackage.module_2"
		root = namespace "mypackage.module_1"

		class root.B extends module_2.A

`m2.coffee`

	define [
		"mypackage.module_1.B"
	], ->
		console.log("run it as #3")		

		module_1 = namespace "mypackage.module_1"
		root = namespace "mypackage.module_2"

		class root.C extends module_1.B

	define [
		# actually this will be executed immediately. 
		# I've put this empty define just to fit global convention
	], ->
		console.log("run it as #1")

		root = namespace "mypackage.module_2"
		class root.A

`result`

	window:
		mypackage:
			module_1:
				B extends A
			module_2:
				A
				C extends B