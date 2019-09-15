input = ""
File.open("input23.txt", 'r') {|f| input = f.read}

nanobots, strongest = [], 0
input.scan(/pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/) do |captures|
	x, y, z, r = captures.collect{|s| s.to_i}
	nanobots << {:x => x, :y => y, :z => z, :r => r}
	strongest = nanobots.length - 1 if r > nanobots[strongest][:r]
end
x, y, z, r, botcount = nanobots[strongest][:x], nanobots[strongest][:y], nanobots[strongest][:z], nanobots[strongest][:r], 0
nanobots.each {|bot| botcount += 1 if (bot[:x] - x).abs + (bot[:y] - y).abs + (bot[:z] - z).abs <= r}

puts "Part 1: #{botcount} (#{botcount = 761 ? 'correct' : 'incorrect!'})"

def score(nanobots, x, y, z)
	botcount = 0
	nanobots.each {|bot| botcount += 1 if (bot[:x] - x).abs + (bot[:y] - y).abs + (bot[:z] - z).abs <= bot[:r]}
	return botcount
end
def count_cube(nanobots, minx, maxx, miny, maxy, minz, maxz)
	count = 0
	nanobots.each do |bot|
		if bot[:x] >= minx && bot[:x] <= maxx && bot[:y] >= miny && bot[:y] <= maxy && bot[:z] >= minz && bot[:z] <= maxz
			count += 1
		else
			x, y, z = bot[:x], bot[:y], bot[:z]
			x = maxx if bot[:x] > maxx
			x = minx if bot[:x] < minx
			y = maxy if bot[:y] > maxy
			y = miny if bot[:y] < miny
			z = maxz if bot[:z] > maxz
			z = minz if bot[:z] < minz
			count += 1 if (bot[:x] - x).abs + (bot[:y] - y).abs + (bot[:z] - z).abs <= bot[:r]
		end
	end
	return {:count => count, :minx => minx, :maxx => maxx, :miny => miny, :maxy => maxy, :minz => minz, :maxz => maxz}
end
infinity = 1.0 / 0
minx, miny, minz, maxx, maxy, maxz = infinity, infinity, infinity, -infinity, -infinity, -infinity
nanobots.each do |bot|
	minx = bot[:x] if bot[:x] < minx
	miny = bot[:y] if bot[:y] < miny
	minz = bot[:z] if bot[:z] < minz
	maxx = bot[:x] if bot[:x] > maxx
	maxy = bot[:y] if bot[:y] > maxy
	maxz = bot[:z] if bot[:z] > maxz
end
bestbc, scores = score(nanobots, 0, 0, 0), [{:count => 0, :minx => minx, :maxx => maxx, :miny => miny, :maxy => maxy, :minz => minz, :maxz => maxz}]
loop do
	nextscores = []
	scores.each do |s|
		minx, maxx, miny, maxy, minz, maxz = s[:minx], s[:maxx], s[:miny], s[:maxy], s[:minz], s[:maxz]
		midx, midy, midz = (minx + maxx) / 2, (miny + maxy) / 2, (minz + maxz) / 2
		x1, x2, x3, x4 = minx, midx, midx, maxx
		x2, x3 = minx, maxx if maxx - minx <= 1
		y1, y2, y3, y4 = miny, midy, midy, maxy
		y2, y3 = miny, maxy if maxy - miny <= 1
		z1, z2, z3, z4 = minz, midz, midz, maxz
		z2, z3 = minz, maxz if maxz - minz <= 1
		nextscores << count_cube(nanobots, x1, x2, y1, y2, z1, z2)
		nextscores << count_cube(nanobots, x3, x4, y1, y2, z1, z2)
		nextscores << count_cube(nanobots, x1, x2, y3, y4, z1, z2)
		nextscores << count_cube(nanobots, x3, x4, y3, y4, z1, z2)
		nextscores << count_cube(nanobots, x1, x2, y1, y2, z3, z4)
		nextscores << count_cube(nanobots, x3, x4, y1, y2, z3, z4)
		nextscores << count_cube(nanobots, x1, x2, y3, y4, z3, z4)
		nextscores << count_cube(nanobots, x3, x4, y3, y4, z3, z4)
	end
	best_score = 0
	nextscores.each {|ns| best_score = ns[:count] if ns[:count] > best_score}
	nextscores.delete_if {|ns| ns[:count] < best_score}
	nextscores.uniq!
	scores = nextscores
	break if scores.count == 1 && scores[0][:minx] == scores[0][:maxx] && scores[0][:miny] == scores[0][:maxy] && scores[0][:minz] == scores[0][:maxz]
end
region = scores[0]
best_distance = region[:minx].abs + region[:miny].abs + region[:minz].abs

puts "Part 2: #{best_distance} (#{best_distance == 89915526 ? 'correct' : 'incorrect!'})"
