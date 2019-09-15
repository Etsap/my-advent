input = ""
File.open("input13.txt", 'r') {|f| input = f.read}

def open(x, y)
    bitcount, value = 0, x * (x + 3 + (y<<1)) + y * (1 + y) + 1358 #input hard-coded
    begin
        bitcount += 1 if value & 1 == 1
    end while (value = value >> 1) > 0
    return bitcount & 1 == 0
end
visited, to_visit, steps = {}, [[1,1], nil], 0
begin
    location = to_visit.delete_at(0)
    if location == nil
        steps += 1
        to_visit << nil
        locations = visited.count if steps == 51
    else
        x, y = location
        visited["(#{x},#{y})"] = true
        to_visit << [x-1, y] if x > 0 && !visited["(#{x-1},#{y})"] && open(x-1, y)
        to_visit << [x+1, y] if !visited["(#{x+1},#{y})"] && open(x+1, y)
        to_visit << [x, y-1] if y > 0 && !visited["(#{x},#{y-1})"] && open(x, y-1)
        to_visit << [x, y+1] if !visited["(#{x},#{y+1})"] && open(x, y+1)
    end
end until visited["(31,39)"]

puts "Part 1: #{steps}"
puts "Part 2: #{locations}"
