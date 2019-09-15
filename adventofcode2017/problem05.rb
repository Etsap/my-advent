input = ""
File.open("input05.txt", 'r') {|f| input = f.read}

result1, result2, location, jumps = 0, 0, 0, input.split(/\n/).collect{|x| x.to_i}
while location >= 0 && location < jumps.count
    jumps[location], location, result1 = jumps[location] + 1, location + jumps[location], result1 + 1
end
location, jumps = 0, input.split(/\n/).collect{|x| x.to_i}
while location >= 0 && location < jumps.count
    jumps[location], location, result2 = jumps[location] + (jumps[location] >= 3 ? -1 : 1), location + jumps[location], result2 + 1
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
