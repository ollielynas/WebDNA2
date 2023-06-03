extends Object



enum Chemical {
	Food1,   # can be used to feed the mitochondria
	ATP,	 # is needed by pretty much everything
	Water,	
	Waste,   # is produced by the mitochondria and other things
}

enum InstructionType {
	Stop = -2,
	DoOnce,
	IfChemicalPresent,
	IfChemicalNotPresent,
	IfChemicalAbove,
	IfChemicalBelow,
	GrowActiveConsumer,
	GrowActiveExcreter,
	ConsumeChemical,
	ExcreteChemical,
	GrowChloroplast,
	None,
}



enum GeneType {
	Stop,
	If_,
	Chemical,
	Instruction,
	None,
	Quantity,
}



export var genes = ""
export var gene_type = []
var in_if = []

func _onload():
	for _i in range(100):
		gene_type.append(GeneType.None)
		in_if.append(false)


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

	for _bundled in range(105):
		gene_type.append(GeneType.None)
		in_if.append(false)
	var i = 0
	var b = false
	while i < genes.length():
		match gene_to_int(genes[i]):
			-1:
				gene_type[i] = GeneType.None
			
			InstructionType.Stop:
				b=false
				gene_type[i] = GeneType.Stop
			InstructionType.DoOnce, InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow, InstructionType.IfChemicalPresent, InstructionType.IfChemicalNotPresent:
				gene_type[i] = GeneType.If_
				b=true
				if gene_to_int(genes[i]) in [InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow, InstructionType.IfChemicalPresent, InstructionType.IfChemicalNotPresent]:
					i+=1
					if genes.length() <= i:genes += " "

					gene_type[i] = GeneType.Chemical
				if gene_to_int(genes[i]) in [InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow]:
					i+=1
					if genes.length() <= i:genes += " "
					gene_type[i] = GeneType.Quantity
			
			InstructionType.GrowActiveConsumer, InstructionType.GrowActiveExcreter:
				gene_type[i] = GeneType.Instruction
		
			InstructionType.ConsumeChemical, InstructionType.ExcreteChemical:
				gene_type[i] = GeneType.Instruction
				i+=1
				gene_type[i] = GeneType.Chemical
			_: 
				gene_type[i] = GeneType.None
		i+=1
		in_if[i] = b
	for rem in range(i, 100):
		gene_type[rem] = GeneType.None
		in_if[rem] = b




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
