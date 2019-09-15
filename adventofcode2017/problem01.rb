input = ""
File.open("input01.txt", 'r') {|f| input = f.read}

part1input = input + input[0]
result1 = result2 = 0
part1input.scan(/(.)(?=\1)/).each do |capture|
    result1 += capture[0].to_i
end
half = input.length/2
(0..input.length-1).each do |i|
    result2 += input[i].to_i if input[i] == input[(i+half) % input.length]
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
