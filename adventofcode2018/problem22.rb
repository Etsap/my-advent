require 'set'
input = ""
File.open("input22.txt", 'r') {|f| input = f.read}

def fill_location!(map, depth, x, y, targetx, targety)
	return map[y][x] if y < map.count && x < map[y].count && map[y][x] != nil
	gi = nil
	if x == 0 && y == 0 || x == targetx && y == targety
		gi = 0
	elsif x == 0
		gi = y * 48271
		map << [] if y == map.count
	elsif y == 0
		gi = x * 16807
	else
		fill_location!(map, depth, x, y-1, targetx, targety) if map[y-1][x] == nil
		if y >= map.count || map[y][x-1] == nil
			map << []
			fill_location!(map, depth, x-1, y, targetx, targety)
		end
		gi = map[y][x-1][:level] * map[y-1][x][:level]
	end
	el = (gi + depth) % 20183
	rl = el % 3
	map[y][x] = {:level => el, :type => rl}
end
depth, map, risk_level = input.match(/depth: (\d+)/).captures[0].to_i, [], 0
targetx, targety = input.match(/target: (\d+),(\d+)/).captures.collect{|s| s.to_i}
(0..targety).each do |y|
	map << []
	(0..targetx).each do |x|
		risk_level += fill_location!(map, depth, x, y, targetx, targety)[:type]
	end
end

puts "Part 1: #{risk_level} (#{risk_level == 11575 ? 'correct' : 'incorrect!'})"

def check_and_add(map, depth, x, y, e, targetx, targety, neighbors)
	type = fill_location!(map, depth, x, y, targetx, targety)[:type]
	neighbors << {:key=>"#{x},#{y}#{e}",:x=>x,:y=>y,:e=>e} if type == 0 && (e == ?c || e == ?t) || type == 1 && (e == ?c || e == ?n) || type == 2 && (e == ?t || e == ?n)
end
infinity, goal, visited, to_visit_queue, to_visit_set, gScore, fScore = 1.0 / 0, "#{targetx},#{targety}t", Set[], ["0,0t"], Set["0,0t"], {"0,0t" => 0}, [targetx + targety]
while goal != key = to_visit_queue.pop
	fScore.pop
	to_visit_set.delete(key)
	visited.add(key)
	x, y, e = key.match(/(\d+),(\d+)(.)/).captures
	x, y = x.to_i, y.to_i
	neighbors = []
	check_and_add(map, depth, x-1, y, e, targetx, targety, neighbors) if x > 0
	check_and_add(map, depth, x, y-1, e, targetx, targety, neighbors) if y > 0
	check_and_add(map, depth, x+1, y, e, targetx, targety, neighbors)
	check_and_add(map, depth, x, y+1, e, targetx, targety, neighbors)
	[?c, ?n, ?t].each {|c| check_and_add(map, depth, x, y, c, targetx, targety, neighbors) if c != e}
	neighbors.each do |neighbor|
		nkey = neighbor[:key]
		next if visited.include?(nkey)
		tentative_gScore = gScore[key]
		if e == neighbor[:e]
			tentative_gScore += 1
		else
			tentative_gScore += 7
		end
		next if gScore.has_key?(nkey) && tentative_gScore >= gScore[nkey]
		gScore[nkey] = tentative_gScore
		tentative_fScore = gScore[nkey] + (targetx - neighbor[:x]).abs + (targety - neighbor[:y]).abs
		tentative_fScore += 7 if neighbor[:e] != ?t
		if to_visit_set.include?(nkey)
			i = to_visit_queue.index(nkey)
			to_visit_queue.delete_at(i)
			fScore.delete_at(i)
		else
			i = 0
			to_visit_set.add(nkey)
		end
		j = to_visit_queue.count
		while i != j && fScore[i] > tentative_fScore
			midpoint = (i + j) >> 1
			if fScore[midpoint] > tentative_fScore
				i = i == midpoint ? j : midpoint
			else
				j = midpoint
			end
		end
		to_visit_queue.insert(i, nkey)
		fScore.insert(i, tentative_fScore)
	end
end
time = gScore[goal]

puts "Part 2: #{time} (#{time == 1068 ? 'correct' : 'incorrect!'})"
