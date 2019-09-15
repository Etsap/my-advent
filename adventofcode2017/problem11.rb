input = ""
File.open("input11.txt", 'r') {|f| input = f.read}

# http://keekerdc.com/2011/03/hexagon-grids-coordinate-systems-and-distance-calculations/
result1, result2, path, x, y, z = 0, 0, input.split(/,/), 0, 0, 0
path.each do |step|
    x += 1 if step == "ne" || step == "se"
    x -= 1 if step == "sw" || step == "nw"
    y += 1 if step == "nw" || step == "n"
    y -= 1 if step == "se" || step == "s"
    z += 1 if step == "s" || step == "sw"
    z -= 1 if step == "ne" || step == "n"
    distance = [x, y, z].collect{|i| i.abs}.sort[2]
    result2 = distance if distance > result2
end
result1 = [x, y, z].collect{|i| i.abs}.sort[2]

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
