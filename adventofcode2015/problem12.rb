input = ""
File.open("input12.txt", 'r') {|f| input = f.read}

def addnumbers(input)
	total = 0
	input.scan(/-?\d+/) {|number| total += number.to_i}
	return total
end
def remove_red!(input)
	input.gsub!(/\{[^{}]*\}/) {|match| match =~ /:"red"/ ? 0 : addnumbers(match)} while input =~ /{/
	return input
end

puts "Part 1: #{addnumbers(input)}"
puts "Part 2: #{remove_red!(input)}"
