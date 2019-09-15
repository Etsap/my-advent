input = ""
File.open("input16.txt", 'r') {|f| input = f.read}

correct_aunt = {"children" => 3, "cats" => 7, "samoyeds" => 2, "pomeranians" => 3, "akitas" => 0, "vizslas" => 0, "goldfish" => 5, "trees" => 3, "cars" => 2, "perfumes" => 1}
aunts = {}
input.split(/\n/).each do |line|
	sue, attributes = line.match(/Sue (\d+): (.*)/).captures
	aunts[sue.to_i] = {}
	attributes.split(/, /).each do |pair|
		attribute, value = pair.match(/(\w+): (\d+)/).captures
		aunts[sue.to_i][attribute] = value.to_i
	end
end
def find_aunt!(correct_aunt, aunts, proc)
	aunts.delete_if {|index, aunt| proc.call(correct_aunt, aunt)}.keys[0]
end
correct_aunt1 = Proc.new{|correct_aunt, aunt|
	result = false
	aunt.each_pair {|key, value| result = true if value != correct_aunt[key]}
	result
}
correct_aunt2 = Proc.new{|correct_aunt, aunt|
	result = false
	aunt.each_pair do |key, value|
		if key == "cats" || key == "trees"
			result = true if value <= correct_aunt[key]
		elsif key == "pomeranians" || key == "goldfish"
			result = true if value >= correct_aunt[key]
		elsif value != correct_aunt[key]
			result = true
		end
	end
	result
}

puts "Part 1: #{find_aunt!(correct_aunt, aunts.clone, correct_aunt1)}"
puts "Part 2: #{find_aunt!(correct_aunt, aunts, correct_aunt2)}"
