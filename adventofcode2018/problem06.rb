input = ""
File.open("input06.txt", 'r') {|f| input = f.read}

coordinates, regions, infinity, part2 = [], {}, 1.0/0, 0
minx, miny, maxx, maxy = infinity, infinity, -infinity, -infinity
input.scan(/(\d+), (\d+)/).each do |captures|
    x, y = captures[0].to_i, captures[1].to_i
    minx = x if x < minx
    maxx = x if x > maxx
    miny = y if y < miny
    maxy = y if y > maxy
    coordinates << [x, y]
    regions["#{x},#{y}"] = 0
end
size = maxx * maxy
for x in minx..maxx
    for y in miny..maxy
        tie, total_distance, bestx, besty, best = false, 0, 0, 0, infinity
        coordinates.each do |pair|
            distance = (pair[0] - x).abs + (pair[1] - y).abs
            total_distance += distance
            if best > distance
                best = distance
                bestx = pair[0]
                besty = pair[1]
                tie = false
            elsif best == distance
                tie = true
            end
        end
        unless tie
            key = "#{bestx},#{besty}"
            if regions.has_key?(key)
                regions[key] += 1
                regions.delete(key) if x == minx || x == maxx || y == miny || y == maxy
            end
        end
        part2 += 1 if total_distance < 10000
    end
end
best = 0
regions.each_value do |count|
    best = count if count > best
end

puts "Part 1: #{best} (#{best == 3293 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{part2} (#{part2 == 45176 ? 'correct' : 'incorrect!'})"
