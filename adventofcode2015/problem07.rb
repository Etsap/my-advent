input = ""
File.open("input07.txt", 'r') {|f| input = f.read}

def processsignals(input)
	signals = input.split(/\n/)
	while signals.count > 0
		signal = signals.delete_at(0)
		if signal =~ /[a-z].*->/
			signals << signal
		else
			input1, operation, input2, output = signal.match(/(\d+ )?([A-Z]+ )?(\d+) -> (\w+)/).captures
			value = nil
			value = (input1.to_i << input2.to_i) & 65535 if operation == "LSHIFT "
			value = (input1.to_i >> input2.to_i) if operation == "RSHIFT "
			value = input1.to_i & input2.to_i if operation == "AND "
			value = input1.to_i | input2.to_i if operation == "OR "
			value = ~(input2.to_i) & 65535 if operation == "NOT "
			value = input2.to_i unless value
			signals.each {|signal| signal.gsub!(/\b#{output}\b/, value.to_s)}
			return value if output == "a"
		end
	end
end

puts "Part 1: #{a = processsignals(input)}"
puts "Part 2: #{processsignals(input.gsub!(/^\d+ -> b$/, "#{a} -> b"))}"
