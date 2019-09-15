require 'set'
if false
    puts Time.now
    input = ""
    File.open("input21.txt", 'r') {|f| input = f.read}

    def execute(program, ipr, registers, part2 = false)
        possible_part2_solutions, ip = Set[], 0
        loop do
            line = program[ip]
            opcode, input1, input2, output = line[:opcode], line[:input1], line[:input2], line[:output]
            registers[ipr] = ip
            registers[0] = registers[5] if ip == 28 && !part2
            case opcode
            when "addi"
                registers[output] = registers[input1] + input2
            when "addr"
                registers[output] = registers[input1] + registers[input2]
            when "seti"
                registers[output] = input1
            when "muli"
                registers[output] = registers[input1] * input2
            when "gtrr"
                registers[output] = registers[input1] > registers[input2] ? 1 : 0
            when "bani"
                registers[output] = registers[input1] & input2
            when "gtir"
                registers[output] = input1 > registers[input2] ? 1 : 0
            when "setr"
                registers[output] = registers[input1]
            when "bori"
                registers[output] = registers[input1] | input2
            when "eqri"
                registers[output] = registers[input1] == input2 ? 1 : 0
            when "eqrr"
                registers[output] = registers[input1] == registers[input2] ? 1 : 0
            when "mulr"
                registers[output] = registers[input1] * registers[input2]
            when "banr"
                registers[output] = registers[input1] & registers[input2]
            when "borr"
                registers[output] = registers[input1] | registers[input2]
            when "gtri"
                registers[output] = registers[input1] > input2 ? 1 : 0
            when "eqir"
                registers[output] = input1 == registers[input2] ? 1 : 0
            end
            ip = registers[ipr]
            ip += 1
            break unless program[ip]
            if ip == 28 && part2
                if possible_part2_solutions.include?(registers[5])
                    registers[0] = part2
                    break
                end
                possible_part2_solutions.add(registers[5])
                part2 = registers[5]
            end
        end
    end
    program, registers = input.split(/\n/), [0] * 6
    ipr = program.delete_at(0).match(/#ip (\d)/).captures[0].to_i
    program.each_index do |i|
        opcode, input1, input2, output = program[i].match(/(....) (\d+) (\d+) (\d+)/).captures
        input1, input2, output = input1.to_i, input2.to_i, output.to_i
        program[i] = {:opcode => opcode, :input1 => input1, :input2 => input2, :output => output}
    end
    execute(program, ipr, registers)
    part1 = registers[0]
    puts "Part 1: #{part1} (#{part1 == 2884703 ? 'correct' : 'incorrect!'})"
    puts Time.now

    registers = [0] * 6
    execute(program, ipr, registers, true)
    part2 = registers[0]
    puts "Part 2: #{part2} (#{part2 == 15400966 ? 'correct' : 'incorrect!'})"
    puts Time.now
end

# reverse-engineered from input
def find_next_terminal_value(x = 0)
    x, y = 733884, x | 65536
    while y > 0
        x = (((x + (y & 255)) & 16777215) * 65899) & 16777215
        y >>= 8
    end
    return x
end
x = find_next_terminal_value
puts "Part 1: #{x} (#{x == 2884703 ? 'correct' : 'incorrect!'})"

unique_outputs, part2 = Set[], nil
part2, x = x, find_next_terminal_value(x) while unique_outputs.add?(x)
puts "Part 2: #{part2} (#{part2 == 15400966 ? 'correct' : 'incorrect!'})"
