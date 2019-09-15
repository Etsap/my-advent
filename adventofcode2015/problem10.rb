input = ""
File.open("input10.txt", 'r') {|f| input = f.read}

File.open("temp_input.txt", 'w') {|f| f.write(input)}
for i in 0..49
	File.open("temp_output.txt", 'w') do |output|
		File.open("temp_input.txt", 'r') do |input|
			counter, prev_char = 0, ''
			input.each_char do |c|
				if c == prev_char
					counter += 1
				else
					output.write(counter.to_s + prev_char) if prev_char != ''
					counter, prev_char = 1, c
				end
			end
			output.write(counter.to_s + prev_char)
		end
	end
	puts "Part 1: #{File.size("temp_output.txt")}" if i == 39
	File.rename("temp_output.txt", "temp_input.txt")
end

puts "Part 2: #{File.size("temp_input.txt")}"
File.delete("temp_input.txt")
