extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"




onready var dna = get_node("WheelEditor/Dna")
onready var wheel = get_node("WheelEditor")


var table = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var p = JavaScript.eval("new URL(window.location.href).searchParams.get('p')")


	if p != null:
		dna.set_dna(p)
		wheel.update()
		wheel.update_all_children()

	for i in range(64):
		table.append({"command":"", "value":"%s"% (float(i)/64), "key":i, "Chemical":"", "char": dna.get_gene(i)})
	table.append({"command":"end if", "value":"", "key":-2, "Chemical":"", "char": "~"})


	for v in dna.InstructionType:
		if dna.InstructionType[v]<0:
			continue
		print(v)
		table[dna.InstructionType[v]]["command"] = v
	
	for v in dna.Chemical:
		table[dna.Chemical[v]]["Chemical"] = v



func _on_MenuButton_pressed():
	var p = JavaScript.eval("window.location.href")
	p = p if p != null else "url_error:?"
	p=p.split("?")[0]
	p += "?p=" + dna.genes.replace(" ", "")
	OS.clipboard = p
	JavaScript.eval("navigator.clipboard.writeText('" +p+ "')")

