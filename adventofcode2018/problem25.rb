starttime, input = Time.now, ""
File.open("input25.txt", 'r') {|f| input = f.read}

coords, constellation, count, i = [], [], 0, nil
input.scan(/(-?\d+),(-?\d+),(-?\d+),(-?\d+)/).each {|match| coords << match.collect{|s| s.to_i}}
# This 4-line version takes over 25 seconds to run, as opposed to the other which runs sub-second.
# This version may actually be worse than N-squared.  The other version is only N-squared.
#while coords.count > 0
#	constellation, count = [coords.pop], count + 1
#	constellation << coords.delete_at(i) while i = coords.index{|c| constellation.index{|n| (c[0]-n[0]).abs+(c[1]-n[1]).abs+(c[2]-n[2]).abs+(c[3]-n[3]).abs <= 3}}
#end
while coords.count > 0
	constellation, count, indexes = [coords[-1]], count + 1, [-1]
	while indexes.count > 0
		coords.delete_at(i) while i = indexes.pop
		next_iteration = []
		coords.each_index do |i|
			c = coords[i]
			if constellation.index{|n| (c[0]-n[0]).abs+(c[1]-n[1]).abs+(c[2]-n[2]).abs+(c[3]-n[3]).abs <= 3}
				indexes << i
				next_iteration << c
			end
		end
		constellation = next_iteration
	end
end

puts "Part 1: #{count} (#{count == 370 ? 'correct' : 'incorrect!'}) in #{Time.now - starttime} seconds"
