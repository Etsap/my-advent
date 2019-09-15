input = ""
File.open("input10.txt", 'r') {|f| input = f.read}

def get_yrange(points)
    miny = maxy = points[0][:y]
    points.each do |point|
        miny = point[:y] if point[:y] < miny
        maxy = point[:y] if point[:y] > maxy
    end
    return miny, maxy
end
points = []
input.scan(/position=<([ -]\d+), ([ -]\d+)> velocity=<([ -]\d+), ([ -]\d+)>/) do |coords|
    points << {:x => coords[0].to_i, :y => coords[1].to_i, :dx => coords[2].to_i, :dy => coords[3].to_i}
end
miny, maxy = get_yrange(points)
delta_y, iteration = maxy - miny + 1, 0
while delta_y > maxy - miny
    delta_y, iteration = maxy - miny, iteration + 1
    points.each { |point| point[:x], point[:y] = point[:x] + point[:dx], point[:y] + point[:dy] }
    miny, maxy = get_yrange(points)
end
points.each { |point| point[:x], point[:y] = point[:x] - point[:dx], point[:y] - point[:dy] }
output, iteration = [], iteration - 1
miny, maxy = get_yrange(points)
minx = maxx = points[0][:x]
points.each do |point|
    minx = point[:x] if point[:x] < minx
    maxx = point[:x] if point[:x] > maxx
end
(maxy - miny + 1).times {output << "." * (maxx - minx + 1)}
points.each {|point| output[point[:y] - miny][point[:x] - minx] = "#"}

puts "Part 1: #{} (BXJXJAEX)"
output.each {|line| puts line}
puts "Part 2: #{iteration} (#{iteration == 10605 ? 'correct' : 'incorrect!'})"
