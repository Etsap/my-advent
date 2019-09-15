require 'set'
input = ""
File.open("input25.txt", 'r') {|f| input = f.read}

result1, tape, cursor, state, steps, instructions = 0, Set[], 0, input.match(/Begin in state (.*?)\./).captures[0], input.match(/Perform a diagnostic checksum after (\d+) steps\./).captures[0], {}
input.scan(/In state (.*?):.*?If the current value is 0:.*?Write the value (\d).*?Move one slot to the (right|left).*?Continue with state (.*?)\..*?If the current value is 1:.*?Write the value (\d).*?Move one slot to the (right|left).*?Continue with state (.*?)\./m).each do |instruction|
    instructions[instruction[0]+"0"] = {:write => instruction[1].to_i, :move => instruction[2] == "right" ? 1 : -1, :next => instruction[3]}
    instructions[instruction[0]+"1"] = {:write => instruction[4].to_i, :move => instruction[5] == "right" ? 1 : -1, :next => instruction[6]}
end
steps.to_i.times do
    read = tape.include?(cursor) ? "1" : "0"
    instruction = instructions[state + read]
    if instruction[:write] == 1
        tape.add(cursor)
    else
        tape.delete(cursor)
    end
    cursor += instruction[:move]
    state = instruction[:next]
end
result1 = tape.count
puts "Part 1: #{result1}"
