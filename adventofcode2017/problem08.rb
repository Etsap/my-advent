input = ""
File.open("input08.txt", 'r') {|f| input = f.read}

result1, result2, registers = 0, 0, {}
input.split(/\n/).each do |line|
    register, operation, value, conreg, conop, conval = line.match(/(\w+) (inc|dec) (-?\d+) if (\w+) ([^ ][^ ]?) (-?\d+)/).captures
    registers[register] = 0 unless registers.has_key?(register)
    registers[conreg] = 0 unless registers.has_key?(conreg)
    conval, value = conval.to_i, operation == "dec" ? -value.to_i : value.to_i
    condition = registers[conreg] < conval && conop == "<" || registers[conreg] > conval && conop == ">" || registers[conreg] <= conval && conop == "<=" || registers[conreg] >= conval && conop == ">=" || registers[conreg] == conval && conop == "==" || registers[conreg] != conval && conop == "!="
    registers[register] += value if condition
    result2 = registers[register] if registers[register] > result2
end
registers.each_value {|value| result1 = value if value > result1}

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
