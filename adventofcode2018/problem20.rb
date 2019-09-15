require 'set'
input = ""
File.open("input20.txt", 'r') {|f| input = f.read}

tree, i, current_node, doors = [{:points => [[0, 0]]}], 1, 0, {}
while i < input.length - 1
    c = input[i]
    if c == "("
        tree << {:points => tree[current_node][:points].collect{|p| p}, :parent => current_node}
        current_node = tree.count - 1
    elsif c == "|"
        current_node = tree[current_node][:parent]
        tree << {:points => tree[current_node][:points].collect{|p| p}, :parent => current_node}
        current_node = tree.count - 1
    elsif c == ")"
        parent = tree[current_node][:parent]
        new_points = []
        tree[parent+1..current_node].each {|leaf| new_points += leaf[:points]}
        tree = tree[0..parent]
        current_node = parent
        tree[current_node][:points] = new_points.uniq
    else
        dx = dy = 0
        if c == "N"
            dy = -1
        elsif c == "S"
            dy = 1
        elsif c == "W"
            dx = -1
        else
            dx = 1
        end
        tree[current_node][:points].map! do |p|
            newx, newy = p[0], p[1]
            key = "#{newx},#{newy}"
            newkey = "#{newx += dx},#{newy += dy}"
            doors[key] = Set[] unless doors.has_key?(key)
            doors[newkey] = Set[] unless doors.has_key?(newkey)
            doors[key].add(newkey)
            doors[newkey].add(key)
            [newx, newy]
        end
    end
    i += 1
end
path, visited, to_visit, part2 = 0, Set[], Set["0,0"], 0
loop do
    next_to_visit = Set[]
    to_visit.each {|point| visited.add(point)}
    to_visit.each do |point|
        doors[point].each do |next_point|
            next_to_visit.add(next_point) if !visited.include?(next_point)
        end
    end
    break if next_to_visit.count == 0
    path += 1
    part2 += next_to_visit.size if path >= 1000
    to_visit = next_to_visit
end

puts "Part 1: #{path} (#{path == 3669 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{part2} (#{part2 == 8369 ? 'correct' : 'incorrect!'})"
