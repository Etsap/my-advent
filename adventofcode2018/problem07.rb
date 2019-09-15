input = ""
File.open("input07.txt", 'r') {|f| input = f.read}

def get_next_step!(prerequisites, keys)
    keys.each do |key|
        if prerequisites[key].count == 0
            prerequisites.delete(key)
            keys.delete(key)
            return key
        end
    end
    return nil
end
def parse_input(input)
    prerequisites = {}
    input.scan(/Step (.) must be finished before step (.) can begin./).each do |captures|
        captures.each do |step|
            prerequisites[step] = [] unless prerequisites.has_key?(step)
        end
        prerequisites[captures[1]] << captures[0]
    end
    return prerequisites, prerequisites.keys.sort
end
prerequisites, prerequisite_keys = parse_input(input)
steps = ""
prerequisite_keys.count.times do
    step = get_next_step!(prerequisites, prerequisite_keys)
    steps += step
    prerequisites.each_value {|value| value.delete(step)}
end
puts "Part 1: #{steps} (#{steps == 'BFGKNRTWXIHPUMLQVZOYJACDSE' ? 'correct' : 'incorrect!'})"

time, workers = 0, {}
prerequisites, prerequisite_keys = parse_input(input)
loop do
    workers.each_key do |step|
        if 0 == workers[step] -= 1
            prerequisites.each_value {|value| value.delete(step)}
            workers.delete(step)
        end
    end
    while workers.count < 5
        key = get_next_step!(prerequisites, prerequisite_keys)
        break unless key
        workers[key] = 61 + key.ord - 'A'.ord
    end
    break if workers.count == 0
    time += 1
end
puts "Part 2: #{time} (#{time == 1163 ? 'correct' : 'incorrect!'})"
