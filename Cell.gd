extends Object



enum Chemical {
	Food1,   # can be used to feed the mitochondria
	ATP,	 # is needed by pretty much everything
	Water,	
	Waste,   # is produced by the mitochondria and other things
	Signal_1,
	Signal_2,
	Signal_3,
	Signal_4,
	Signal_5,
	Signal_6,
	Signal_7,
}


enum InstructionType {
	DoOnce,
	IfChemicalPresent,
	IfChemicalNotPresent,
	IfChemicalAbove,
	IfChemicalBelow,
	GrowActiveConsumer,
	GrowActiveExcreter,
	ConsumeChemical,
	ExcreteChemical,
	IfFeelerAtAngle
	
	Stop = -2,
}

func return_types(in_type:int):
	match in_type:
		InstructionType.DoOnce:return [GeneType.If_]
		InstructionType.IfChemicalPresent:return [GeneType.If_, GeneType.Chemical]
		InstructionType.IfChemicalNotPresent:return [GeneType.If_, GeneType.Chemical]
		InstructionType.IfChemicalAbove:return [GeneType.If_, GeneType.Chemical, GeneType.Quantity]
		InstructionType.IfChemicalBelow:return [GeneType.If_, GeneType.Chemical, GeneType.Quantity]
		InstructionType.GrowActiveConsumer:return [GeneType.Instruction]
		InstructionType.GrowActiveExcreter:return [GeneType.Instruction]
		InstructionType.ConsumeChemical:return [GeneType.Instruction, GeneType.Chemical]
		InstructionType.ExcreteChemical:return [GeneType.Instruction, GeneType.Chemical]
		InstructionType.IfFeelerAtAngle:return [GeneType.If_, GeneType.Angle]
		InstructionType.Stop:return [GeneType.Stop]
	return [GeneType.None]


enum GeneType {
	Stop,
	If_,
	Chemical,
	Instruction,
	None,
	Quantity,
	Angle,
}



export var genes = ""
export var gene_type = []
var in_if = []

func _ready():
	for _i in range(100):
		gene_type.append(GeneType.None)
		in_if.append(false)
	update_genes()


func get_gene_from_dna_index(index:int):
	if index < 0 or index >= genes.length():
		return " "
	return genes[index]

func set_gene_from_dna_index(n:int, gene:String):
	if n < 0 or n >= genes.length():
		print("set_gene_from_dna_index: n out of range")
		genes += " ".repeat(n - genes.length() + 1)
	
	genes = genes.substr(0, n) + gene + genes.substr(n+1)
	print(genes)
	update_genes()

func get_name(index:int):
	var gene_int = gene_to_int(get_gene_from_dna_index(index))
	match get_type(index):
		GeneType.Stop:
			return "Stop"
		GeneType.If_:
			if gene_int >= 0 and gene_int < InstructionType.keys().size():
					return InstructionType.keys()[gene_int]
		GeneType.Chemical:
			if gene_int >= 0 and gene_int < Chemical.keys().size():
					return Chemical.keys()[gene_int]
		GeneType.Instruction:
			if gene_int >= 0 or gene_int < InstructionType.keys().size():
					return InstructionType.keys()[gene_int]
		GeneType.None:
			return " "
		GeneType.Quantity:
			return "%s" % gene_int 
		GeneType.Angle:
			return "%s deg" % (float(gene_int) / 64 * 360)
	return " "
	

func get_gene(n:int):
	if n == -2:
		return "~"
	if n > 63:
		return " "
	var gene = "abcdefghijklmnopqrstuvwxyz0123456789+/=ABCDEFGHIJKLMNOPQRSTUVWXYZ"[n]
	if gene == null:
		return " "
	
	return gene

func gene_to_int(c:String):
	if c == "~":
		return -2
	if c == " ":
		return -1
	

	return "abcdefghijklmnopqrstuvwxyz0123456789+/=ABCDEFGHIJKLMNOPQRSTUVWXYZ".find(c)



func update_genes():
	print("update_genes")
	in_if = []
	gene_type = []


	var i = 0
	var b = false
	while i < 100:
		var r = return_types(gene_to_int(get_gene_from_dna_index(i)))
		i+=r.size()
		if r[0] == GeneType.Stop:
			b = false
		if r[0] == GeneType.If_:
			b = true
		var f = [false]
		f.resize(r.size())
		f.fill(b)
		in_if.append_array(f)
		gene_type.append_array(r)



func set_dna(string: String):
	genes = string
	gene_type = []
	for _i in range(100):
		gene_type.append(GeneType.None)
	update_genes()


func get_type(n:int):
	if n < 0 or n >= gene_type.size():
		return GeneType.None
	return gene_type[n]


func get_color_from_type(n:int):

	match n:
		GeneType.Stop:
			# red
			return Color(1, 0.392157, 0.392157)
		GeneType.If_:
			# orange
			return Color(1, 0.862745, 0.392157)
		GeneType.Chemical:
			# purple
			return Color(0.771072, 0.399902, 0.875)
		GeneType.Instruction:
			# green
			return Color(0.562893, 0.921875, 0.399719)
		GeneType.Quantity:
			# blue
			return Color(0.399719, 0.713829, 0.991875)
		GeneType.None:
			# black
			return Color(0.945313, 0.945313, 0.945313)
		GeneType.Angle:
			# yellow
			return Color(0.991875, 0.991875, 0.399719)
