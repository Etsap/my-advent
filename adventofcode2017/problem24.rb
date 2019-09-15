input = ""
File.open("input24.txt", 'r') {|f| input = f.read}

def build_bridge(bridge, components, pins, strength, best, longest, best_longest)
    components[pins].each do |next_component|
        next if bridge.include?(next_component)
        bridge.push(next_component)
        strength += next_component[2]
        best = strength if strength > best
        best_longest = strength if strength > best_longest && bridge.count == longest
        if bridge.count > longest
            longest = bridge.count
            best_longest = strength
        end
        best, longest, best_longest = build_bridge(bridge, components, next_component[0] == pins ? next_component[1] : next_component[0], strength, best, longest, best_longest)
        bridge.pop()
        strength -= next_component[2]
    end
    return best, longest, best_longest
end
components = {}
input.split(/\n/).each do |line|
    component = line.match(/(.*)\/(.*)/).captures.collect{|c| c.to_i}.sort
    component << component[0] + component[1]
    components[component[0]] = [] unless components.has_key?(component[0])
    components[component[1]] = [] unless components.has_key?(component[1])
    components[component[0]] << component
    components[component[1]] << component
end
result1, result2, longest = components[0][0][2], components[0][0][2], 1
components[0].each do |start|
    bridge = [start]
    result1, longest, result2 = build_bridge(bridge, components, start[1], start[2], result1, longest, result2)
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
