require 'set'

input = ""
File.open("input01.txt", 'r') {|f| input = f.read}

frequencies, input = Set[0], input.split(/\n/)
def loop(input, frequencies, current = 0, result2 = nil)
    input.each do |line|
        current += line.to_i
        result2 = current if frequencies.include?(current) && result2 == nil
        frequencies.add(current)
    end
    return current, result2
end
current, result2 = loop(input, frequencies)
puts "Part 1: #{current} (#{current == 561 ? 'correct' : 'incorrect!'})"

current, result2 = loop(input, frequencies, current, result2) while result2 == nil
puts "Part 2: #{result2} (#{result2 == 563 ? 'correct' : 'incorrect!'})"
