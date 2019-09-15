input = ""
File.open("input01.txt", 'r') {|f| input = f.read}

x = y = facing = 0
locations = [[0,0]]
final = nil
for instruction in input.split(', ')
    facing -= 1 if instruction[0] == "L"
    facing += 1 if instruction[0] == "R"
    facing = facing % 4
    distance = instruction[1..instruction.length].to_i
    if final
        y += distance if facing == 0
        x += distance if facing == 1
        y -= distance if facing == 2
        x -= distance if facing == 3
    else
       distance.times do
            y += 1 if facing == 0
            x += 1 if facing == 1
            y -= 1 if facing == 2
            x -= 1 if facing == 3
            final = [x, y] if locations.include?([x, y])
            locations << [x, y]
        end
    end
end

puts "Part 1: #{x.abs + y.abs}"
puts "Part 2: #{final[0].abs + final[1].abs}"
