input = ""
File.open("input19.txt", 'r') {|f| input = f.read}

replacements = {}
molecule = ""
reverse_replacements = {}
input.split(/\n/).each do |n|
	if n =~ / => /
		key, value = n.split(/ => /)
		replacements[key] = [] unless replacements[key]
		replacements[key] << value
		reverse_replacements[value] = key
	else
		molecule = n
	end
end
results = []
replacements.each_key do |key|
	start = 0
	while i = molecule.index(key, start)
		replacements[key].each do |value|
			new_result = value + molecule[i+key.length..molecule.length]
			new_result = molecule[0..i-1] + new_result if i > 0
			results << new_result
		end
		start = i + 1
	end
end
substitutions = 0
while molecule != "e"
	reverse_replacements.each_pair do |key, value|
		substitutions += 1 while molecule.sub!(key, value)
	end
end

puts "Part 1: #{results.uniq.count}"
puts "Part 2: #{substitutions}"
