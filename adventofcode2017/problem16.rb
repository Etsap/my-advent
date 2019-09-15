input = ""
File.open("input16.txt", 'r') {|f| input = f.read}

def dance(state, instructions)
    instructions.each do |instruction|
        if instruction[0] == "s"
            size = instruction.match(/s(\d+)/).captures[0].to_i
            state = state[-size..-1] + state[0..state.length-size-1]
        elsif instruction[0] == "x"
            i, j = instruction.match(/x(\d+)\/(\d+)/).captures.collect{|c| c.to_i}
            state[i], state[j] = state[j], state[i]
        elsif instruction[0] == "p"
            a, b = instruction.match(/p(.+)\/(.+)/).captures
            ia, ib = state.index(a), state.index(b)
            state[ia], state[ib] = b, a
        end
    end
    return state
end
result1, instructions, results = "abcdefghijklmnop", input.split(/,/), []
results << result1.clone
result1 = dance(result1, instructions)
results << result1.clone
state = result1.clone
while true
    state = dance(state, instructions)
    break if state == "abcdefghijklmnop"
    results << state.clone
end
result2 = results[1000000000 % results.count]

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
