input = ''
File.open("input08.txt", 'r') {|f| input = f.read}

def find_total!(lines, function, total = 0)
	lines.each {|line| total += function.call(line)}
	return total
end
calc1 = Proc.new{|line|
	len = line.length
	line.gsub!(/(^"|"$)/, "").gsub!(/\\("|\\|x[0-9a-f][0-9a-f])/, ".")
	len -= line.length
}
calc2 = Proc.new{|line|
	len = -line.length
	line.gsub!(/("|\\)/, "..")
	len += line.length + 2
}

puts "Part 1: #{find_total!(input.split(/\n/), calc1)}"
puts "Part 2: #{find_total!(input.split(/\n/), calc2)}"
