input = ""
File.open("input23.txt", 'r') {|f| input = f.read}

def valueOf(arg, registers)
    return arg =~ /[a-d]/ ? registers[arg] : arg.to_i 
end
def evaluate_loops(instructions)
    loops = []
    instructions.each_index do |i|
        if match = instructions[i].match(/^jnz ([a-d]) -2/)
            counter, increment = match.captures[0], nil
            if instructions[i-1] =~ /^dec #{counter}/ && instructions[i-2] =~ /^inc/
                increment = instructions[i-2].match(/^inc ([a-d])/).captures[0]
            elsif instructions[i-2] =~ /^dec #{counter}/ && instructions[i-1] =~ /^inc/
                increment = instructions[i-1].match(/^inc ([a-d])/).captures[0]
            end
            loops[i-2] = "add #{counter} #{increment}" if increment
        elsif (match = instructions[i].match(/^jnz ([a-d]) -5/)) && loops[i-4] =~ /^add/
            counter = match.captures[0]
            if instructions[i-1] =~ /^dec #{counter}/ && match = instructions[i-5].match(/^cpy ([a-d]|[0-9]+) ([a-d])/)
                value1 = match.captures[0]
                if match = loops[i-4].match(/^add #{match.captures[1]} ([a-d])/)
                    loops[i-5] = "mul #{value1} #{counter} #{match.captures[0]}"
                end
            end
        end
    end
    return loops
end
def do_calcs(instructions, init_a)
    registers, line_number, loops = {"a" => init_a, "b" => 0, "c" => 0, "d" => 0}, 0, evaluate_loops(instructions)
    while line_number < instructions.count
        if loops[line_number]
            if match = loops[line_number].match(/^add ([a-d]) ([a-d])/)
                registers[match.captures[1]] += registers[match.captures[0]]
                registers[match.captures[0]] = 0
                line_number += 3
            else
                match = loops[line_number].match(/mul ([a-d]|\d+) ([a-d]) ([a-d])/)
                registers[match.captures[2]] += valueOf(match.captures[0], registers) * registers[match.captures[1]]
                registers[match.captures[1]] = 0
                registers[loops[line_number+1].match(/^add ([a-d])/).captures[0]] = 0
                line_number += 6
            end
        else
            operation, arg1, arg2 = instructions[line_number].match(/^(...) ([a-d]|-?\d+) ?([a-d]|-?\d+)?/).captures
            if operation == "jnz"
                line_number += valueOf(arg1, registers) != 0 ? valueOf(arg2, registers) : 1
            else
                if operation == "inc"
                    registers[arg1] += 1
                elsif operation == "dec"
                    registers[arg1] -= 1
                elsif operation == "cpy"
                    registers[arg2] = valueOf(arg1, registers)
                else # operation == "tgl"
                    value1 = valueOf(arg1, registers)
                    if instructions[line_number + value1] =~ /^inc/
                        instructions[line_number + value1].sub!(/^inc/, 'dec')
                    elsif instructions[line_number + value1] =~ /^(dec|tgl)/
                        instructions[line_number + value1].sub!(/^(dec|tgl)/, 'inc')
                    elsif instructions[line_number + value1] =~ /^jnz/
                        instructions[line_number + value1].sub!(/^jnz/, 'cpy')
                    elsif instructions[line_number + value1] =~ /^cpy/
                        instructions[line_number + value1].sub!(/^cpy/, 'jnz')
                    end
                    loops = evaluate_loops(instructions)
                end
                line_number += 1
            end
        end
    end
    return registers["a"]
end

puts "Part 1: #{do_calcs(input.split(/\n/), 7)}" #12480 = (7! + 80 * 93)
puts "Part 2: #{do_calcs(input.split(/\n/), 12)}" #479009040 = (12! + 80 * 93)
