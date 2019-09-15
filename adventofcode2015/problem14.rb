input = ""
File.open("input14.txt", 'r') {|f| input = f.read}

inputdata, bestdistance, maxpoints = [], 0, 0
input.split(/\n/).each do |line|
	deer, speed, flyduration, restduration = line.match(/(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+)/).captures
	inputdata << {"speed" => speed.to_i, "fly" => flyduration.to_i, "rest" => restduration.to_i, "distance" => 0, "points" => 0}
end
for i in 0..2502
	maxdistance = 0
	inputdata.each do |deer|
		tick = i % (deer["fly"] + deer["rest"])
		deer["distance"] += deer["speed"] if tick < deer["fly"]
		maxdistance = deer["distance"] if deer["distance"] > maxdistance
	end
	inputdata.each {|deer| deer["points"] += 1 if deer["distance"] == maxdistance}
end
inputdata.each {|deer| bestdistance = deer["distance"] if deer["distance"] > bestdistance}
inputdata.each {|deer| maxpoints = deer["points"] if deer["points"] > maxpoints}

puts "Part 1: #{bestdistance}"
puts "Part 2: #{maxpoints}"
