input = ""
File.open("input23.txt", 'r') {|f| input = f.read}

def run_simulation(input, a = 0)
	instructions, registers, i = input.split(/\n/), {"a" => a, "b" => 0}, 0
	while i >= 0 && i < instructions.count
		instruction, register, offset = instructions[i].match(/(...) ([^, ]+),? ?([-+]\d*)?/).captures
		if instruction == "hlf"
			registers[register] /= 2
		elsif instruction == "tpl"
			registers[register] *= 3
		elsif instruction == "inc"
			registers[register] += 1
		end
		i += 1
		if instruction[0] == "j"
			offset = register if instruction == "jmp"
			sign, offset = offset.match(/([-+])(\d+)/).captures
			offset = offset.to_i
			offset = -offset if sign == "-"
			i += offset - 1 if instruction == "jmp" || instruction == "jie" && registers[register] % 2 == 0 || instruction == "jio" && registers[register] == 1
		end
	end
	return registers["b"]
end

puts "Part 1: #{run_simulation(input)}"
puts "Part 2: #{run_simulation(input, 1)}"
