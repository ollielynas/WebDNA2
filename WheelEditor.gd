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
	# get mouse speed


func _input(event):
	if  Input.is_action_just_pressed("scroll_up"):
		set_rotation(get_rotation() + 0.06)
	if Input.is_action_just_pressed("scroll_down"):
		set_rotation(get_rotation() - 0.06)

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(int(100)):
		var new = preload("res://Gene.tscn").instance()

		new.set_rotation(i*((2*PI)/100))
		new.text = Dna.get_gene_from_dna_index(i)
		new.index = i
		children.append(new)
		control.add_child(new)
		new.rect_position = Vector2(300, 0)

	print("size %s" % children.size())
	update()


# func _process(delta):
# 	pass

func update_child_text():
	for i in range(children.size()):
		children[i].set("text", Dna.get_gene_from_dna_index(i))



func set_dna(dna):
	Dna.set_dna(dna)

func update_all_children():
	for i in children:
		i.update()
		

