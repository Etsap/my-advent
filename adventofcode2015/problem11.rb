input = ""
File.open("input11.txt", 'r') {|f| input = f.read}

def incrementletter!(input, i)
	input[i] = (input[i].ord + 1).chr
	return input if input[i] <= 'z'
	input[i] = 'a'
	incrementletter!(input, i - 1) if i > 0
	return input
end
def validpassword?(input)
	return false if input =~ /[iol]/
	return false unless input =~ /(.)\1.*(.)\2/
	for i in 0..input.length-3
		return true if input[i+1].ord == input[i].ord + 1 && input[i+2].ord == input[i].ord + 2
	end
	return false
end
def nextpassword!(input)
	begin incrementletter!(input, input.length-1) end while !validpassword?(input)
	return input
end

puts "Part 1: #{nextpassword!(input)}"
puts "Part 2: #{nextpassword!(input)}"
