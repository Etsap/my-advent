input = ""
File.open("input08.txt", 'r') {|f| input = f.read}

def depthfirst(tree, metadata_sum = 0, i = 0)
    child_count, metadata_count, node_value = tree[i], tree[i+1], 0
    i += 2
    children = []
    child_count.times do
        metadata_sum, child_value, i = depthfirst(tree, metadata_sum, i)
        children << child_value
    end
    metadata_count.times do
        metadata_sum += tree[i]
        node_value += children[tree[i]-1] if tree[i] > 0 && tree[i] <= child_count
        node_value += tree[i] if child_count == 0
        i += 1
    end
    return metadata_sum, node_value, i
end
metadata_sum, value = depthfirst(input.split(/ /).collect{|x| x.to_i})

puts "Part 1: #{metadata_sum} (#{metadata_sum == 44838 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{value} (#{value == 22198 ? 'correct' : 'incorrect!'})"
