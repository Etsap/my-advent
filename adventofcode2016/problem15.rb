input = ""
File.open("input15.txt", 'r') {|f| input = f.read}

def done?(discs)
    (1..discs.count-1).each {|i| return false unless (discs[i]["position"] + i) % discs[i]["positions"] == 0}
    return true
end
def parse_input(input)
    discs = []
    input.split(/\n/).each do |line|
        disc, positions, position = line.match(/Disc #(\d+) has (\d+) positions; at time=0, it is at position (\d+)./).captures
        discs[disc.to_i] = {"positions" => positions.to_i, "position" => position.to_i, "included" => false}
    end
    return discs
end
def do_process(discs)
    time, increment = 0, discs[1]["positions"] - discs[1]["position"] - 1
    while !done?(discs)
        time += increment # advance time
        discs.each {|disc| disc["position"] = (disc["position"] + increment) % disc["positions"] if disc} # advance discs
        (1..discs.count-1).each {|i| discs[i]["included"] = (discs[i]["position"] + i) % discs[i]["positions"] == 0} # check
        increment = discs.collect{|disc| disc["positions"] if disc && disc["included"]}.compact.reduce(:lcm) # calculate new increment
    end
    return time
end

puts "Part 1: #{do_process(parse_input(input))}"

discs = parse_input(input)
discs << {"positions" => 11, "position" => 0}

puts "Part 2: #{do_process(discs)}"
