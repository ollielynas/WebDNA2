extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var control = get_node("Control")
var children = []
onready var Dna = get_node("Dna")

var table = []

var current_focus = 0

func set_focus(n):
	current_focus = n


# Called when the node enters the scene tree for the first time.
func _ready():
	table = get_parent().table
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




func set_dna(dna):
	Dna.set_dna(dna)
	for i in range(children.size()):
		children[i].set("text", Dna.get_gene_from_dna_index(i))

func update_all_children():
	for i in children:
		i.update()
		

