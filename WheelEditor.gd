extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var control = get_node("Control")
var children = []
onready var Dna = get_node("Dna")

var current_focus = 0

func set_focus(n):
	current_focus = n


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(int(100)):
		var new = preload("res://Gene.tscn").instance()
		new.set_rotation(i*((2*PI)/100))
		new.index = i
		children.append(new)
		control.add_child(new)
	
	print("size %s" % children.size())
	update()

# func _process(delta):
# 	pass


func update_2(_a, i:int):
	print("update %s" % i)
	Dna.set_gene_from_dna_index(i, children[i].get("text") if children[i].get("text") != null else " ")
	update()
	Dna.update_genes()


func set_dna(dna):
	Dna.set_dna(dna)
	for i in range(children.size()):
		children[i].set("text", Dna.get_gene_from_dna_index(i))
	update()

func update():
	Dna.update_genes()
	for child in children:
		child.set("self_modulate", Dna.get_color_from_type(Dna.get_type(child.index)))
		# children[i].set_label(Dna.gene_to_int(Dna.get_gene_from_dna_index(i)) if Dna.get_type(i) == Dna.GeneType.Quantity else "%s" % i)
		child.set_label(Dna.get_gene_from_dna_index(child.index))

