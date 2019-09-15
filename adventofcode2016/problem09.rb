input = ""
File.open("input09.txt", 'r') {|f| input = f.read}

def calculate_length(input, with_recursion = true)
    result = 0
    while matches = input.match(/([^(]*)\((\d+)x(\d+)\)(.*)/)
        data1, length, repeat, data2 = matches.captures
        input = data2[length.to_i..data2.length]
        result += data1.length + (with_recursion ? calculate_length(data2[0..length.to_i-1]) : length.to_i) * repeat.to_i
    end
    result += input.length
    return result
end

puts "Part 1: #{calculate_length(input, false)}"
puts "Part 2: #{calculate_length(input)}"
