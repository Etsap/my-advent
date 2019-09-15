require 'set'
input = ""
File.open("input16.txt", 'r') {|f| input = f.read}

part1, operator_hash = 0, {}
input.scan(/Before: \[(\d+), (\d+), (\d+), (\d+)\]\n(\d+) (\d+) (\d+) (\d+)\nAfter:  \[(\d+), (\d+), (\d+), (\d+)\]/m).each do |sample|
    before_registers = sample[0..3].collect{|x| x.to_i}
    opcode = sample[4]
    input1, input2, output = sample[5..7].collect{|x| x.to_i}
    after_registers = sample[8..11].collect{|x| x.to_i}
    operator_count = 0
    operators = Set[]
    operators.add("addr") if before_registers[input1] + before_registers[input2] == after_registers[output]
    operators.add("addi") if before_registers[input1] + input2 == after_registers[output]
    operators.add("mulr") if before_registers[input1] * before_registers[input2] == after_registers[output]
    operators.add("muli") if before_registers[input1] * input2 == after_registers[output]
    operators.add("banr") if before_registers[input1] & before_registers[input2] == after_registers[output]
    operators.add("bani") if before_registers[input1] & input2 == after_registers[output]
    operators.add("borr") if before_registers[input1] | before_registers[input2] == after_registers[output]
    operators.add("bori") if before_registers[input1] | input2 == after_registers[output]
    operators.add("setr") if before_registers[input1] == after_registers[output]
    operators.add("seti") if input1 == after_registers[output]
    operators.add("gtir") if input1 > before_registers[input2] && after_registers[output] == 1 || input1 <= before_registers[input2] && after_registers[output] == 0
    operators.add("gtri") if before_registers[input1] > input2 && after_registers[output] == 1 || before_registers[input1] <= input2 && after_registers[output] == 0
    operators.add("gtrr") if before_registers[input1] > before_registers[input2] && after_registers[output] == 1 || before_registers[input1] <= before_registers[input2] && after_registers[output] == 0
    operators.add("eqir") if input1 == before_registers[input2] && after_registers[output] == 1 || input1 != before_registers[input2] && after_registers[output] == 0
    operators.add("eqri") if before_registers[input1] == input2 && after_registers[output] == 1 || before_registers[input1] != input2 && after_registers[output] == 0
    operators.add("eqrr") if before_registers[input1] == before_registers[input2] && after_registers[output] == 1 || before_registers[input1] != before_registers[input2] && after_registers[output] == 0
    part1 += 1 if operators.size >= 3
    if operator_hash.has_key?(opcode)
        operator_hash[opcode] &= operators
    else
        operator_hash[opcode] = operators
    end
end

puts "Part 1: #{part1} (#{part1 == 517 ? 'correct' : 'incorrect!'})"

operations = {}
while operator_hash.count > 0
    found = nil
    operator_hash.each_pair do |key, value|
        if value.size == 1
            found = value.to_a[0] 
            operations[key] = found
            break
        end
    end
    operator_hash.each_value {|value| value.delete(found)}
    operator_hash.delete_if{|k,v| v.size == 0}
end
program, registers = input.match(/\n\n\n\n(.*)/m).captures[0].split(/\n/), [0, 0, 0, 0]
program.each do |instruction|
    opcode, input1, input2, output = instruction.match(/(\d+) (\d+) (\d+) (\d+)/).captures.collect{|x| x.to_i}
    operation = operations[opcode.to_s]
    if operation == "addr"
        registers[output] = registers[input1] + registers[input2]
    elsif operation == "addi"
        registers[output] = registers[input1] + input2
    elsif operation == "mulr"
        registers[output] = registers[input1] * registers[input2]
    elsif operation == "muli"
        registers[output] = registers[input1] * input2
    elsif operation == "banr"
        registers[output] = registers[input1] & registers[input2]
    elsif operation == "bani"
        registers[output] = registers[input1] & input2
    elsif operation == "borr"
        registers[output] = registers[input1] | registers[input2]
    elsif operation == "bori"
        registers[output] = registers[input1] | input2
    elsif operation == "setr"
        registers[output] = registers[input1]
    elsif operation == "seti"
        registers[output] = input1
    elsif operation == "gtir"
        registers[output] = input1 > registers[input2] ? 1 : 0
    elsif operation == "gtri"
        registers[output] = registers[input1] > input2 ? 1 : 0
    elsif operation == "gtrr"
        registers[output] = registers[input1] > registers[input2] ? 1 : 0
    elsif operation == "eqir"
        registers[output] = input1 == registers[input2] ? 1 : 0
    elsif operation == "eqri"
        registers[output] = registers[input1] == input2 ? 1 : 0
    elsif operation == "eqrr"
        registers[output] = registers[input1] == registers[input2] ? 1 : 0
    end
end

puts "Part 2: #{registers[0]} (#{registers[0] == 667 ? 'correct' : 'incorrect!'})"
