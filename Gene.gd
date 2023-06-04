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
	# select_all()


func _on_Gene_text_changed(new_text:String):
	dna.set_gene_from_dna_index(index, new_text.substr(0,1) if new_text.substr(0,1).length() > 0 else " ")
	wheel.update_all_children()
	
	select_all()

func set_label(string:String):
	label.set("text", string)


func set_in_if(i:bool):
	color_rect.set("visible", i)


func update():
	var gene_int = dna.gene_to_int(text)
	self_modulate = dna.get_color_from_type(dna.get_type(index))
	set_label(dna.get_name(index))

	color_rect.set("visible", dna.in_if[index])


func _on_Gene_focus_entered():
	select_all()


func _on_Gene_text_change_rejected(rejected_substring:String):
	text = rejected_substring
	dna.set_gene_from_dna_index(index, rejected_substring.substr(0,1) if rejected_substring.substr(0,1).length() > 0 else " ")
	wheel.update_all_children()



