input = ""
File.open("input06.txt", 'r') {|f| input = f.read}

binarylightarray = []
1000.times do binarylightarray << [].fill(0, 0, 1000) end
secondlightarray = []
1000.times do secondlightarray << [].fill(0, 0, 1000) end
turnoff = Proc.new{|x,y|
	binarylightarray[x][y] = 0
	secondlightarray[x][y] -= 1 unless secondlightarray[x][y] == 0}
turnon = Proc.new{|x,y|
	binarylightarray[x][y] = 1
	secondlightarray[x][y] += 1}
toggle = Proc.new{|x,y|
	binarylightarray[x][y] = 1 - binarylightarray[x][y]
	secondlightarray[x][y] += 2}
input.split(/\n/).each do |instruction|
	instruction,x1,y1,x2,y2 = instruction.match(/(\w+) (\d+),(\d+) through (\d+),(\d+)/).captures
	operation = turnon if instruction == "on"
	operation = turnoff if instruction == "off"
	operation = toggle if instruction == "toggle"
	for i in x1.to_i..x2.to_i
		for j in y1.to_i..y2.to_i
			operation.call(i,j)
		end
	end
end

puts "Part 1: #{binarylightarray.flatten.count{|x| x == 1}}"
sum = 0
secondlightarray.flatten.each {|x| sum += x}
puts "Part 2: #{sum}"
