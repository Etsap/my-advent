input = ""
File.open("input23.txt", 'r') {|f| input = f.read}

def value(x, registers)
    if x.match(/[a-z]/)
        registers[x] = 0 if !registers.has_key?(x)
        return registers[x]
    end
    return x.to_i
end
def run(instructions, registers)
    current_instruction = 0
    result1 = 0
    while current_instruction >= 0 && current_instruction < instructions.count
        instruction, arg1, arg2 = instructions[current_instruction].match(/(...) ([^ ]+) ([^ ]+)/).captures
        if instruction == "set"
            registers[arg1] = value(arg2, registers)
        elsif instruction == "sub"
            registers[arg1] = value(arg1, registers) - value(arg2, registers)
        elsif instruction == "mul"
            result1 += 1
            registers[arg1] = value(arg1, registers) * value(arg2, registers)
        end
        current_instruction += 1
        current_instruction = current_instruction - 1 + value(arg2, registers) if instruction == "jnz" && value(arg1, registers) != 0
    end
    return result1
end
result1, result2, instructions, registers = 0, 0, input.split(/\n/), {}
result1 = run(instructions, registers)
#registers = {"a" => 1}
#result2 = run(instructions, registers)
#Programmatic answer above; below achieved through analysis of input.
def prime?(number)
    (2..number-1).each {|f| return false if number % f == 0}
    return true
end
b = 109300
while b <= 126300
    result2 += 1 if !prime?(b)
    b += 17
end
puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
