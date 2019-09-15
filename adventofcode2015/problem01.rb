input = ""
File.open("input01.txt", 'r') {|f| input = f.read}

floor = 0
basement = 0
for i in 0..input.length-1
	floor += input[i] == "(" ? 1 : -1
	basement = i+1 if floor < 0 && basement == 0
end

puts "Part 1: #{floor}"
puts "Part 2: #{basement}"
