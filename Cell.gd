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

func _onload():
	for _i in range(100):
		gene_type.append(GeneType.None)
	


func get_gene_from_dna_index(index:int):
	if index < 0 or index >= genes.length():
		return " "
	return genes[index]

func set_gene_from_dna_index(n:int, gene:String):

	if n < 0 or n >= genes.length():
		genes += " ".repeat(n - genes.length() + 1)
		
	genes[n] = gene
	update_genes()
	

func get_gene(n:int):
	if n == -2:
		return "~"
	
	var gene = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="[n]
	if gene == null:
		return " "
	
	return gene

func gene_to_int(c:String):
	if c == "~":
		return -2
	if c == "*":
		return -1
	
	return "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".find(c)



func update_genes():
	print("update_genes")

	for i in range(100):
		while i >= gene_type.size()-2:
			gene_type.append(GeneType.None)
		
		while i >= genes.length()-2:
			genes += " "

		match gene_to_int(genes[i]):
			
			InstructionType.Stop:
				gene_type[i] = GeneType.Stop
			InstructionType.DoOnce, InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow, InstructionType.IfChemicalPresent, InstructionType.IfChemicalNotPresent:
				gene_type[i] = GeneType.If_
				if genes[i] in [InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow, InstructionType.IfChemicalPresent, InstructionType.IfChemicalNotPresent]:
					if i < genes.length():i+=1
					gene_type[i] = GeneType.Chemical
				if genes[i] in [InstructionType.IfChemicalAbove, InstructionType.IfChemicalBelow]:
					if i < genes.length():i+=1
					gene_type[i] = GeneType.Quantity
			
			InstructionType.GrowActiveConsumer, InstructionType.GrowActiveExcreter:
				gene_type[i] = GeneType.Instruction
		
			InstructionType.ConsumeChemical, InstructionType.ExcreteChemical:
				gene_type[i] = GeneType.Instruction
				if i < genes.length():i+=1
				gene_type[i] = GeneType.Chemical
			


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
			return Color(0.80603, 0.84671, 0.96875)
