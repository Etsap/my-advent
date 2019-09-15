input = ""
File.open("input09.txt", 'r') {|f| input = f.read}

graph = {}
def addtograph!(graph, location1, location2, distance)
	graph[location1] = {} unless graph.has_key?(location1)
	graph[location1][location2] = distance
end
input.split(/\n/).each do |line|
	location1, location2, distance = line.match(/(\w+) to (\w+) = (\d+)/).captures
	addtograph!(graph, location1, location2, distance.to_i)
	addtograph!(graph, location2, location1, distance.to_i)
end
def bestdistance(graph, worstdistance, comparison)
	unvisited, totalroute = graph.keys, 0
	tripstart = tripend = unvisited.delete_at(0)
	while unvisited.count > 0
		bestkey, bestdistance = "", worstdistance
		unvisited.each do |key|
			bestkey, bestdistance = key, graph[tripstart][key] if comparison.call(graph[tripstart][key], bestdistance)
			bestkey, bestdistance = key, graph[tripend][key] if comparison.call(graph[tripend][key], bestdistance)
		end
		if comparison.call(graph[tripstart][bestkey], graph[tripend][bestkey])
			tripstart = bestkey
		else
			tripend = bestkey
		end
		unvisited.delete(bestkey)
		totalroute += bestdistance
	end
	return totalroute
end

puts "Part 1: #{bestdistance(graph, 1.0 / 0, Proc.new{|a, b| a < b})}"
puts "Part 2: #{bestdistance(graph, 0, Proc.new{|a, b| a > b})}"
