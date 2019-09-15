input = ""
File.open("input10.txt", 'r') {|f| input = f.read}

def do_iteration(circle, twists, current_position, skip_size)
    twists.each do |twist_length|
        if current_position + twist_length <= circle.count
            if current_position > 0
                circle = circle[0..current_position-1] + circle[current_position..current_position+twist_length-1].reverse() + circle[current_position+twist_length..circle.count-1]
            else
                circle = circle[0..current_position+twist_length-1].reverse() + circle[current_position+twist_length..circle.count-1]
            end
        else
            circle = circle + circle
            circle = circle[0..current_position-1] + circle[current_position..current_position+twist_length-1].reverse() + circle[current_position+twist_length..circle.count-1]
            if twist_length < circle.count
                circle = circle[circle.count/2..current_position+twist_length-1] + circle[current_position-circle.count/2+twist_length..circle.count/2-1]
            else
                circle = circle[circle.count/2..current_position+twist_length-1-circle.count/2+current_position] + circle[current_position..circle.count/2-1]
            end
        end
        current_position += (twist_length + skip_size)
        current_position %= circle.count
        skip_size += 1
    end
    return circle, current_position, skip_size
end
result1, result2, circle, twists, current_position, skip_size = 0, 0, (0..255).to_a, input.split(/,/).collect{|x| x.to_i}, 0, 0
circle, x, y = do_iteration(circle, twists, current_position, skip_size)
result1 = circle[0] * circle[1]
twists = input.chars.collect{|c| c.ord} + [17, 31, 73, 47, 23]
circle, current_position, skip_size = (0..255).to_a, 0, 0
64.times do
    circle, current_position, skip_size = do_iteration(circle, twists, current_position, skip_size)
end
i, dense_hash = 0, []
while i < 255
    result, j = circle[i], i+1
    while j < i + 16
        result = result ^ circle[j]
        j = j + 1
    end
    dense_hash << result
    i = j
end
result2 = dense_hash.collect{|c| ("0"+c.to_s(16))[-2..-1]}.join

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
