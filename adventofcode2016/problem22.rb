input = ""
File.open("input22.txt", 'r') {|f| input = f.read}

nodes = input.scan(/\/dev\/grid\/node-x(\d+)-y(\d+) +(\d+)T +(\d+)T +(\d+)T +(\d+)%/).collect{|match| {:x => match[0].to_i, :y => match[1].to_i, :size => match[2].to_i, :used => match[3].to_i, :avail => match[4].to_i}}
pairs = 0
nodes.each {|nodeA| nodes.each {|nodeB| pairs += 1 if (nodeA[:x] != nodeB[:x] || nodeA[:y] != nodeB[:y]) && nodeA[:used] > 0 && nodeA[:used] <= nodeB[:avail]}}

puts "Part 1: #{pairs}"

def hash(state)
    return ["#{state[1]}, #{state[2]}, #{state[3]}, #{state[4]}", state[1], state[2], state[3], state[4], state[5]]
end
def next_states(dy, dx, ey, ex, steps, grid) # assumes all moveable nodes are interchangeable (all have used < 80 < size in my input)
    ns = []
    ns << hash(["", ey-1 == dy && ex == dx ? dy+1 : dy, dx, ey-1, ex, steps+1]) if ey > 0 && grid[ey-1][ex][:used] < grid[ey][ex][:size]
    ns << hash(["", ey+1 == dy && ex == dx ? dy-1 : dy, dx, ey+1, ex, steps+1]) if ey + 1 < grid.count && grid[ey+1][ex][:used] < grid[ey][ex][:size]
    ns << hash(["", dy, ey == dy && ex-1 == dx ? dx+1 : dx, ey, ex-1, steps+1]) if ex > 0 && grid[ey][ex-1][:used] < grid[ey][ex][:size]
    ns << hash(["", dy, ey == dy && ex+1 == dx ? dx-1 : dx, ey, ex+1, steps+1]) if ex + 1 < grid[0].count && grid[ey][ex+1][:used] < grid[ey][ex][:size]
    return ns
end
grid, empty, visited, steps, done = [], [], {}, 0, false
nodes.each do |node|
    grid[node[:y]] = [] unless grid[node[:y]]
    grid[node[:y]][node[:x]] = {:used => node[:used], :size => node[:size]}
    empty[0], empty[1] = node[:y], node[:x] if node[:used] == 0 # assumes only a single empty node is empty
end
unvisited = [hash(["", 0, grid[0].count-1, empty[0], empty[1], steps])]
while !done
    state = unvisited.delete_at(0)
    next if visited[state[0]]
    steps, visited[state[0]], done = state[5], true, state[1] == 0 && state[2] == 0
    next_states(state[1], state[2], state[3], state[4], state[5], grid).each do |nextstate|
        unvisited << nextstate unless visited[nextstate[0]]
    end
end

puts "Part 2: #{steps}"
