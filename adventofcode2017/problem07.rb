input = ""
File.open("input07.txt", 'r') {|f| input = f.read}

def recurse(node, nodes)
    childhash = {}
    nodes[node][:children].each do |child|
        if nodes[child].has_key?(:children)
            kids = recurse(child, nodes)
            return kids unless kids.is_a?(Hash)
            childhash[child] = nodes[child][:weight] + kids.count * kids[kids.keys[0]]
        else
            childhash[child] = nodes[child][:weight]
        end
    end
    if childhash.values.uniq.count > 1
        reversekids, correctvalue, incorrectvalue = {}, nil, nil
        childhash.each_pair do |key, value|
            reversekids[value] = [] unless reversekids[value]
            reversekids[value] << key
        end
        reversekids.each_pair do |key, value|
            if value.count > 1
                correctvalue = key
            else
                incorrectvalue = key
            end
        end
        return nodes[reversekids[incorrectvalue][0]][:weight] - incorrectvalue + correctvalue
    end
    return childhash
end
result1, result2, allchildren, nodes = 0, 0, [], {}
input.split(/\n/).each do |inputline|
    node, weight, x, children = inputline.match(/(\w+) \((\d+)\)( -> (.*))?/).captures
    nodes[node] = {:weight => weight.to_i}
    nodes[node][:children] = children.split(", ") if children
    nodes[node][:children].each {|child| allchildren << child} if children
end
result1 = (nodes.keys - allchildren)[0]
result2 = recurse(result1, nodes)

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
