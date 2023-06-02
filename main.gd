extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"




onready var dna = get_node("WheelEditor/Dna")
onready var wheel = get_node("WheelEditor")


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = JavaScript.eval("new URL(window.location.href).searchParams.get('p')")


	if p != null:
		dna.set_dna(p)
		wheel.update()




func _on_MenuButton_pressed():
	var p = JavaScript.eval("new URL(window.location.href)")
	p = p if p != null else "something when wrong:"
	p += "?p=" + dna.genes

	OS.clipboard = p
	JavaScript.eval("navigator.clipboard.writeText('" +p+ "')")
