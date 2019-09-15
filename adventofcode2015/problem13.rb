input = ""
File.open("input13.txt", 'r') {|f| input = f.read}

grid = {}
input.split(/\n/).each do |line|
	first, operation, amount, second = line.match(/(\w+) would (\w+) (\d+) happiness units by sitting next to (\w+)\./).captures
	grid[first] = {} unless grid.has_key?(first)
	grid[first][second] = operation == "gain" ? amount.to_i : -amount.to_i
end
def find_seating(grid)
	best = -1.0 / 0
	last_seat = grid.keys.count-1
	grid.keys.permutation do |seating|
		total = 0
		seating.each_index do |i|
			prior_seat = i-1
			prior_seat = last_seat if i == 0
			total += grid[seating[i]][seating[prior_seat]]
			total += grid[seating[prior_seat]][seating[i]]
		end
		best = total if total > best
	end
	return best
end

puts "Part 1: #{find_seating(grid)}"

grid["self"] = {}
grid.keys.each {|person| grid[person]["self"], grid["self"][person] = 0, 0}

puts "Part 2: #{find_seating(grid)}"
