extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var index = 0
	
onready var label = get_node("Label")
onready var wheel = get_parent().get_parent()
onready var dna = wheel.get_node("Dna")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


func _on_Gene_text_changed(new_text:String):
	dna.set_gene_from_dna_index(index, new_text.substr(0,1))
	
func set_label(string:String):
	label.set("text", string)