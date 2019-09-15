input = ""
File.open("input14.txt", 'r') {|f| input = f.read}

def knot_hash(input)
    circle, current_position, skip_size = (0..255).to_a, 0, 0
    twists = input.chars.collect{|c| c.ord} + [17, 31, 73, 47, 23]
    64.times do
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
    return dense_hash.collect{|c| ("0000000"+c.to_s(2))[-8..-1]}.join
end
result1, result2, memory = 0, 0, []
(0..127).each do |row|
    row_hash = "#{input}-#{row}"
    kh = knot_hash(row_hash)
    result1 += kh.scan(/(1)/).count
    memory[row] = kh.chars
end
memory.each_index do |row|
    memory[row].each_index do |column|
        if memory[row][column] == "1"
            result2 += 1
            to_visit = [[row, column]]
            while visiting = to_visit.pop
                i = visiting[0]
                j = visiting[1]
                memory[i][j] = "0"
                to_visit << [i-1, j] if i > 0 && memory[i-1][j] == "1"
                to_visit << [i+1, j] if i < 127 && memory[i+1][j] == "1"
                to_visit << [i, j-1] if j > 0 && memory[i][j-1] == "1"
                to_visit << [i, j+1] if j < 127 && memory[i][j+1] == "1"
            end
        end
    end
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
