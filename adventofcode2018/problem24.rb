input = ""
File.open("input24.txt", 'r') {|f| input = f.read}

def calcdamage(a, b)
	return 0 if b[:immune].include?(a[:type])
	damage = a[:count] * a[:damage]
	damage <<= 1 if b[:weak].include?(a[:type])
	return damage
end
def do_combat(groups, boost = 0)
	groups.each {|group| group[:damage] += boost if group[:side] == 1}
	while groups.index{|g| g[:side] == 1} && groups.index{|g| g[:side] == -1}
		groups.sort_by!{|g| -(g[:damage] * g[:count] + g[:init])}
		groups.each {|g| g[:targeted] = false}
		groups.each_index do |i|
			best_damage, best_j = 1, -1
			groups.each_index do |j|
				next if groups[i][:side] == groups[j][:side] || groups[j][:targeted]
				damage = calcdamage(groups[i], groups[j])
				best_damage, best_j = damage, j if damage > best_damage || damage == best_damage && (groups[j][:count] * groups[j][:damage] > groups[best_j][:count] * groups[best_j][:damage] || groups[best_j][:count] * groups[best_j][:damage] == groups[j][:count] * groups[j][:damage] && groups[j][:init] > groups[best_j][:init])
			end
			groups[i][:target] = best_j
			groups[best_j][:targeted] = true if best_j > -1
		end
		inits, total_losses = groups.collect{|g| g[:init]}.sort, 0
		while inits.count > 0
			init = inits.pop
			i = groups.index{|g| g[:init] == init}
			next if groups[i][:target] < 0
			target = groups[groups[i][:target]]
			loss = calcdamage(groups[i], target) / target[:hp]
			target[:count] -= loss
			target[:count] = 0 if target[:count] < 0
			total_losses += loss
		end
		return 0 if total_losses == 0 # stalemate
		groups.delete_if{|group| group[:count] == 0}
	end
	return 0 if boost > 0 && groups[0][:side] == -1
	units = 0
	groups.each {|g| units += g[:count]}
	return units
end
def clone_groups(groups)
	new = []
	groups.each {|group| new << group.clone}
	return new
end
groups, side = [], 1
input.split(/\n/).each do |line|
	side = -1 if line == "Infection:"
	if line =~ /^\d/
		group = {:immune => [], :weak => [], :side => side}
		group[:count], group[:hp] = line.match(/(\d+) units each with (\d+) hit points /).captures.collect{|s| s.to_i}
		match = line.match(/immune to ([^;)]*)/)
		match.captures[0].split(/, /).each {|immunity| group[:immune] << immunity} if match
		match = line.match(/weak to ([^;)]*)/)
		match.captures[0].split(/, /).each {|weakness| group[:weak] << weakness} if match
		damage, group[:type], init = line.match(/ with an attack that does (\d+) (\w+) damage at initiative (\d+)/).captures
		group[:damage], group[:init] = damage.to_i, init.to_i / 100.0
		groups << group
	end
end
units = do_combat(clone_groups(groups))

puts "Part 1: #{units} (#{units == 16530 ? 'correct' : 'incorrect!'})"

boost = 1
boost += 1 while 0 == units = do_combat(clone_groups(groups), boost)

puts "Part 2: #{units} (#{units == 3313 ? 'correct' : 'incorrect!'})"
