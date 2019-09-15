input = ""
File.open("input11.txt", 'r') {|f| input = f.read}

floors, elements, index = [[], [], [], []], [], 0
input.split(/\n/).each do |line|
    line.match(/The \w+ floor contains (.*)/).captures[0].split(/, (and )?/).each do |item|
        matches = item.match(/a (\w+)( generator|-compatible microchip)/)
        if matches
            element, type = matches.captures[0], matches.captures[1]
            elements << element unless elements.include?(element)
            floors[index] << "#{elements.index(element)}#{type == " generator" ? "g" : "m"}"
        end
    end
    index += 1
end
def invalid_floor?(floor)
    orphan_microchip_present = generator_present = false
    floor.split(/,/).each do |item|
        material = item.match(/(.)m/).captures[0] if item =~ /.m/
        orphan_microchip_present = true unless floor.include?("#{material}g") if item =~ /.m/
        generator_present = true if item =~ /.g/
    end
    return orphan_microchip_present && generator_present
end
def invalid_state?(state, floor1, floor2)
    mystate = state.gsub(/.*:/, "")
    floors = mystate.split(/\|/)
    return true if floors[floor1] && invalid_floor?(floors[floor1])
    return true if floors[floor2] && invalid_floor?(floors[floor2])
    return false
end
def normalize_state(state)
    location, mystate = state.match(/(\d):(.*)/).captures
    numbers, alphabet = [], "abcdefhijklnopqrstuvwxyz"
    mystate.scan(/(\d)([^\d]+)/) {|match| numbers << match[0] unless numbers.include?(match[0])}
    numbers.each_index {|i| mystate.gsub!(/#{numbers[i]}/,alphabet[i])}
    numbers.each_index {|i| mystate.gsub!(/#{alphabet[i]}/,"#{i}")}
    return "#{location}:#{mystate}"
end
def state_visited_hash(state, elements)
    location, mystate = state.match(/(\d):(.*)/).captures
    pairs = []
    elements.each_index do |i|
        pair = []
        mystate.split(/\|/).each_with_index do |floor, j|
            pair << j if floor =~ /#{i}g/
            pair << j if floor =~ /#{i}m/
        end
        pairs << pair
    end
    return "#{location}#{pairs.sort}"
end
def next_possible_states(state)
    location, mystate = state.match(/(\d):(.*)/).captures
    result, location = [], location.to_i
    floors = mystate.split(/\|/)
    floors << "" if mystate =~ /.*\|/
    floors << "" if mystate =~ /.*\|\|/
    floors << "" if mystate =~ /.*\|\|\|/
    floors.collect!{|floor| floor.split(/,/)}
    [1, -1].each do |direction|
        next if location == 0 && direction == -1 || location == 3 && direction == 1
        (0..floors[location].count-1).each do |i|
            (i+1..floors[location].count).each do |j|
                object1 = floors[location][i]
                object2 = floors[location][j] if i < floors[location].count
                myfloors = floors.collect {|floor| floor.collect{|item| item.dup}}
                myfloors[location].delete(object1)
                myfloors[location].delete(object2)
                myfloors[location+direction] << object1
                myfloors[location+direction] << object2 if object2
                state = "#{location+direction}:#{myfloors.collect{|floor| floor.join(",")}.join("|")}"
                next if invalid_state?(state, location, location+direction)
                result << normalize_state(state)
            end
        end
    end
    return result
end
def do_moves(floors, elements)
    location, visited, depth = 0, {}, 0
    unvisited_states = [normalize_state("#{location}:#{floors.collect{|floor| floor.collect{|item| item}.join(",")}.join("|")}"), nil]
    while unvisited_states.count > 0
        state = unvisited_states.delete_at(0)
        return depth if state =~ /^\d:\|\|\|.*/
        if state == nil
            depth += 1
            unvisited_states << nil
        else
            unvisited_states.concat(next_possible_states(state)) unless visited[state_visited_hash(state, elements)]
            visited[state_visited_hash(state, elements)] = true
        end
    end
end
best1 = do_moves(floors, elements)
elements << "elerium" << "dilithium"
floors[0] << "#{elements.index("elerium")}g" << "#{elements.index("elerium")}m" << "#{elements.index("dilithium")}g" << "#{elements.index("dilithium")}m"
best2 = do_moves(floors, elements)

puts "Part 1: #{best1}"
puts "Part 2: #{best2}"
