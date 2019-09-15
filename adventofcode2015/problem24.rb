input = ""
File.open("input24.txt", 'r') {|f| input = f.read}

numbers = input.split(/\n/).collect{|n| n.to_i}.reverse
sum = 0
numbers.each {|n| sum += n}
def find_values(numbers, sum, tempsum = 0, tempquantity = 0, bestquantity = 1.0 / 0, tempentanglement = 1, bestentanglement = 1.0 / 0)
	if sum == tempsum
		bestentanglement = tempentanglement
		bestquantity = tempquantity
	elsif tempquantity < bestquantity
		numbers.each do |n|
			nextsum = n + tempsum
			nextentanglement = tempentanglement * n
			if nextsum < sum || nextsum == sum && nextentanglement < bestentanglement
				nextnumbers = numbers.clone
				nextnumbers.delete(n)
				bestquantity, bestentanglement = find_values(nextnumbers, sum, nextsum, tempquantity + 1, bestquantity, nextentanglement, bestentanglement)
			end
		end
	end
	return bestquantity, bestentanglement
end

puts "Part 1: #{find_values(numbers, sum / 3)[1]}"
puts "Part 2: #{find_values(numbers, sum / 4)[1]}"
