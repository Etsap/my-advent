input = ""
File.open("input12.txt", 'r') {|f| input = f.read}

def iteration(state, state_offset, statemap)
    i = state.index("#")
    if i < 4
        state = "." * (4-i) + state
        state_offset -= 4-i
    elsif i > 4
        state = state[i-4..-1]
        state_offset += i-4
    end
    while (state[-4..-1] != "....")
        state += "."
    end
    newstate = state[0..1]
    for i in 2..state.length - 3
        newstate += statemap[state[i-2..i+2]]
    end
    newstate += state[-2..-1]
    return newstate, state_offset
end
def sum(state, state_offset)
    sum = 0
    for i in 0..state.length-1
        sum += i + state_offset if state[i] == "#"
    end
    return sum
end
state = /initial state: (.*)/.match(input).captures[0]
statemap = {}
input.scan(/([#\.][#\.][#\.][#\.][#\.]) => ([#\.])/).each do |captures|
    statemap[captures[0]] = captures[1]
end
state_offset = prev_diff = prev_sum = prev_prev_diff = final_sum = 0
20.times do
    state, state_offset = iteration(state, state_offset, statemap)
    this_sum = sum(state, state_offset)
    prev_prev_diff, prev_diff, prev_sum = prev_diff, this_sum - prev_sum, this_sum
end
part1 = sum(state, state_offset)
puts "Part 1: #{part1} (#{part1 == 3915 ? 'correct' : 'incorrect!'})"

i = 20
while i < 50000000000
    i += 1
    state, state_offset = iteration(state, state_offset, statemap)
    this_sum = sum(state, state_offset)
    this_diff = this_sum - prev_sum
    if prev_prev_diff == this_diff
        final_sum = this_diff * (50000000000 - i) + this_sum
        break
    end
    prev_prev_diff, prev_diff, prev_sum = prev_diff, this_sum - prev_sum, this_sum
end

puts "Part 2: #{final_sum} (#{final_sum == 4900000001793 ? 'correct' : 'incorrect!'})"
