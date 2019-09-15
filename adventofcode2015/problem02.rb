input = ""
File.open("input02.txt", 'r') {|f| input = f.read}

paperTotal = 0
ribbonTotal = 0
input.split(/\n/).each do |line|
	dims = line.split(/x/).collect{|x| x.to_i}.sort
	paperTotal += dims[0]*dims[1]*3 + dims[0]*dims[2]*2 + dims[1]*dims[2]*2
	ribbonTotal += (dims[0]+dims[1])*2 + dims[0]*dims[1]*dims[2]
end

puts "Part 1: #{paperTotal}"
puts "Part 2: #{ribbonTotal}"
