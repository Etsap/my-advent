input = ""
File.open("input12.txt", 'r') {|f| input = f.read}

def include_group(nodes, included, i)
    while i < included.count
        nodes[included[i]].each do |node|
            included << node unless included.include?(node)
        end
        i += 1
    end
    return included
end
nodes = []
input.split(/\n/).each do |inputline|
    node, connections = inputline.match(/(\d+) <-> (.*)/).captures
    nodes[node.to_i] = connections.split(/, /).collect{|n| n.to_i}
end
included = include_group(nodes, [0], 0)
result1, j, result2 = included.count, 0, 1
while j < nodes.count
    if !included.include?(j)
        included << j
        result2 += 1
        included = include_group(nodes, included, included.count-1)
    end
    j += 1
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
