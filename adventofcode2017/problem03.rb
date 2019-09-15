input = ""
File.open("input03.txt", 'r') {|f| input = f.read}

result1 = result2 = 0
x, y, square, maxx, maxy, dx, dy = 0, 0, 1, 0, 0, 1, 0
storage = {"0,0" => 1}
while square < input.to_i do
    square, x, y = square + 1, x + dx, y + dy
    if x > maxx
        dx, dy, maxx = 0, 1, maxx + 1
    elsif y > maxy
        dx, dy, maxy = -1, 0, maxy + 1
    elsif dx == -1 && x.abs == maxx
        dx, dy = 0, -1
    elsif dy == -1 && y.abs == maxy
        dx, dy = 1, 0
    end
    if result2 == 0
        sum = 0
        (-1..1).each do |i|
            (-1..1).each do |j|
                sum += storage["#{x+i},#{y+j}"] if (i != 0 || j != 0) && storage.has_key?("#{x+i},#{y+j}")
            end
        end
        storage["#{x},#{y}"] = sum
        result2 = sum if sum > input.to_i
    end
end
result1 = x.abs + y.abs

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
