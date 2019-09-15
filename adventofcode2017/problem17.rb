input = ""
File.open("input17.txt", 'r') {|f| input = f.read}

def iteration(current_position, step, buffer, new_value)
    current_position = (current_position + step) % buffer.count
    zindex = buffer.index(0)
    if current_position <= zindex || new_value < 2018
        buffer.insert(current_position + 1, new_value)
    else
        buffer << 1
    end
    current_position += 1
    return current_position
end
result1, result2, buffer, current_position, step = 0, 0, [0], 0, input.to_i
(1..2017).each do |new_value|
    current_position = iteration(current_position, step, buffer, new_value)
end
result1 = buffer[current_position+1]
(2018..50000000).each do |new_value|
    current_position = iteration(current_position, step, buffer, new_value)
end
result2 = buffer[buffer.index(0) + 1]

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
