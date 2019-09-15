input = ""
File.open("input13.txt", 'r') {|f| input = f.read}

def caught?(layers, delay)
    layers.each_index do |i|
        if layer = layers[i]
            return true if (delay + i) % layer[:repeat] == 0
        end
    end
    return false
end
result1, result2, layers, depth = 0, 0, [], -1
input.split(/\n/).each do |line|
    layer, range = line.match(/(\d+): (\d+)/).captures
    layers[layer.to_i] = {:position => 0, :range => range.to_i, :direction => 1, :repeat => 2 * (range.to_i - 1)}
end
layers_copy = layers.collect{|layer| layer.clone if layer}
while depth < layers.count
    depth += 1
    result1 += depth * layers_copy[depth][:range] if layers_copy[depth].is_a?(Hash) && layers_copy[depth][:position] == 0
    layers_copy.each do |layer|
        next unless layer.is_a?(Hash)
        layer[:direction] = -layer[:direction] if layer[:position] + layer[:direction] == -1 || layer[:position] + layer[:direction] == layer[:range]
        layer[:position] += layer[:direction]
    end
end
result2 += 1 while caught?(layers, result2)

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
