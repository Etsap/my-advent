input = ""
File.open("input18.txt", 'r') {|f| input = f.read}

map = input.split(/\n/).collect{|n| n.split(//)}
def do_corners!(map)
	map[0][0] = '#'
	map[0][99] = '#'
	map[99][0] = '#'
	map[99][99] = '#'
end
def do_iterations!(map, corners)
	do_corners!(map) if corners
	100.times do
		next_map = []
		for i in 0..99
			next_map[i] = []
			for j in 0..99
				lights = 0
				lights += 1 if i > 0 && j > 0 && map[i-1][j-1] == "#"
				lights += 1 if i > 0 && map[i-1][j] == "#"
				lights += 1 if i > 0 && j < 99 && map[i-1][j+1] == "#"
				lights += 1 if j > 0 && map[i][j-1] == "#"
				lights += 1 if j < 99 && map[i][j+1] == "#"
				lights += 1 if i < 99 && j > 0 && map[i+1][j-1] == "#"
				lights += 1 if i < 99 && map[i+1][j] == "#"
				lights += 1 if i < 99 && j < 99 && map[i+1][j+1] == "#"
				next_map[i][j] = "."
				next_map[i][j] = "#" if lights == 3 || lights == 2 && map[i][j] == "#"
			end
		end
		map = next_map
		do_corners!(map) if corners
	end
	total = 0
	map.each {|row| row.each {|value| total += 1 if value == "#"}}
	return total
end

puts "Part 1: #{do_iterations!(map.collect{|row| row.clone}, false)}"
puts "Part 2: #{do_iterations!(map, true)}"
