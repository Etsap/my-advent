input = ""
File.open("input04.txt", 'r') {|f| input = f.read}

require 'digest'
def mine(input, regex, i = 0)
	i += 1 while !(Digest::MD5.hexdigest("#{input}#{i}") =~ regex)
	return i
end

puts "Part 1: #{i = mine(input, /^00000/)}"
puts "Part 2: #{mine(input, /^000000/, i)}"
