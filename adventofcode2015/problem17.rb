input = ""
File.open("input17.txt", 'r') {|f| input = f.read}

containers = input.split(/\n/).collect!{|s| s.to_i}
def find_combination(containers, min_containers, total = 0, index = 0, solution_count = 0, min_solution_count = 0, num_containers = 0)
	for i in index..containers.count-1
		if containers[i] + total == 150
			solution_count += 1
			if num_containers == min_containers
				min_solution_count += 1
			elsif num_containers < min_containers
				min_solution_count = 1
				min_containers = num_containers
			end
		elsif containers[i] + total < 150
			solution_count, min_solution_count, min_containers = find_combination(containers, min_containers, total+containers[i], i+1, solution_count, min_solution_count, num_containers+1)
		end
	end
	return solution_count, min_solution_count, min_containers
end
solutions, min_solutions = find_combination(containers, containers.count)

puts "Part 1: #{solutions}"
puts "Part 2: #{min_solutions}"
