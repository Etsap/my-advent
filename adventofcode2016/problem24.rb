input = ""
File.open("input24.txt", 'r') {|f| input = f.read}

grid, locations = input.split(/\n/), []
grid.each_index {|line| (0..grid[line].length-1).each {|i| locations[grid[line][i].to_i] = [[line, i, 0]] if grid[line][i] =~ /\d/}}
visited, graph = locations.collect{|l| {}}, locations.collect{|l| locations.collect{|l|}}
while graph.index{|g| g.include?(nil)}
    locations.each_index do |i|
        count = locations[i].count
        (0..count-1).each do |j|
            here = locations[i][j]
            visited[i]["#{here[0]},#{here[1]}"] = here[2] unless visited[i]["#{here[0]},#{here[1]}"]
            locations.each_index {|k| graph[k][i] = graph[i][k] = here[2] + visited[k]["#{here[0]},#{here[1]}"] if !graph[i][k] && visited[k]["#{here[0]},#{here[1]}"]}
            locations[i] << [here[0]-1, here[1], here[2]+1] if grid[here[0]-1][here[1]] != "#" && !visited[i]["#{here[0]-1},#{here[1]}"]
            locations[i] << [here[0]+1, here[1], here[2]+1] if grid[here[0]+1][here[1]] != "#" && !visited[i]["#{here[0]+1},#{here[1]}"]
            locations[i] << [here[0], here[1]-1, here[2]+1] if grid[here[0]][here[1]-1] != "#" && !visited[i]["#{here[0]},#{here[1]-1}"]
            locations[i] << [here[0], here[1]+1, here[2]+1] if grid[here[0]][here[1]+1] != "#" && !visited[i]["#{here[0]},#{here[1]+1}"]
        end
        locations[i] = [] unless graph[i].include?(nil)
        locations[i].slice!(0..count-1)
        locations[i].uniq!
    end
end
def find_shortest_route(graph, return_trip)
    shortest_route, route = 0, []
    graph.each {|row| row.each{|item| shortest_route += item}}
    (1..graph.count-1).each{|i| route << i}
    route.permutation do |p| # Brute force!
        this_route = graph[0][p[0]]
        (1..p.count-1).each {|i| this_route += graph[p[i-1]][p[i]]}
        this_route += graph[p[p.count-1]][0] if return_trip
        shortest_route = this_route if shortest_route > this_route
    end
    return shortest_route
end

puts "Part 1: #{find_shortest_route(graph, false)}" #448
puts "Part 2: #{find_shortest_route(graph, true)}" #672
