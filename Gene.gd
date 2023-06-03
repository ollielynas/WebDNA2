extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var index = 0
	
onready var label = get_node("Label")
onready var wheel = get_parent().get_parent()
onready var dna = wheel.get_node("Dna")
onready var color_rect = get_node("ColorRect")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass	


func _on_Gene_text_changed(new_text:String):
	print("Gene text changed")
	dna.set_gene_from_dna_index(index, new_text.substr(0,1) if new_text.substr(0,1).length() > 0 else " ")
	wheel.update_all_children()
	

func set_label(string:String):
	label.set("text", string)


func set_in_if(i:bool):
	color_rect.set("visible", i)


func update():
	self_modulate = dna.get_color_from_type(dna.get_type(index))
	match dna.get_type(index):
		dna.GeneType.Quantity:
			set_label("%s" % dna.gene_to_int(dna.get_gene(index)))
		dna.GeneType.Chemical:
			set_label(wheel.table[dna.gene_to_int(text)]["Chemical"])
		_:
			set_label("")
	color_rect.set("visible", dna.in_if[index])
	
