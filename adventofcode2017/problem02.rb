input = ""
File.open("input02.txt", 'r') {|f| input = f.read}

result1 = result2 = 0
input.split(/\n/).each do |line|
    largest, smallest, quotient = 0, nil, nil
    values = line.split(/\s+/).collect{|value| value.to_i}
    values.each do |value|
        smallest = value.to_i if !smallest || smallest > value.to_i
        largest = value.to_i if largest < value.to_i
        values.each do |value2|
            if value != value2 && value % value2 == 0
                quotient = value / value2
            end
        end
    end
    result1 += largest - smallest
    result2 += quotient
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
