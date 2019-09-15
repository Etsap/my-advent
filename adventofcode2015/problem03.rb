input = ""
File.open("input03.txt", 'r') {|f| input = f.read}

x, y, x2, y2, locations, locations2 = 0, 0, [0, 0], [0, 0], ["0,0"], ["0,0"]
for i in 0..input.length-1
	x-=1 if input[i] == "<"
	x2[i%2]-=1 if input[i] == "<"
	x+=1 if input[i] == ">"
	x2[i%2]+=1 if input[i] == ">"
	y-=1 if input[i] == "v"
	y2[i%2]-=1 if input[i] == "v"
	y+=1 if input[i] == "^"
	y2[i%2]+=1 if input[i] == "^"
	locations << "#{x},#{y}"
	locations2 << "#{x2[i%2]},#{y2[i%2]}"
end

puts "Part 1: #{locations.uniq.count}"
puts "Part 2: #{locations2.uniq.count}"
