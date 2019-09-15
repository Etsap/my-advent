input = ""
File.open("input25.txt", 'r') {|f| input = f.read}

row, column = input.match(/row (\d+), column (\d+)/).captures.collect{|n| n.to_i}
def value_in_sequence(sequence)
	value = 20151125
	(sequence-1).times {value = (value * 252533) % 33554393}
	return value
end

puts "Part 1: #{value_in_sequence((row + column - 1) * (row + column) / 2 + 1 - row)}"
