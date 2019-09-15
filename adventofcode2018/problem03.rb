require 'set'

input = ""
File.open("input03.txt", 'r') {|f| input = f.read}

result1, fabric, claims, conflicts = 0, {}, Set[], Set[]
lines = input.scan(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).each do |capture|
    claim, left, top, width, height = capture.collect {|x| x = x.to_i}
    claims.add(claim)
    conflicts.clear
    for i in left..left+width-1
        for j in top..top+height-1
            key = "#{i},#{j}"
            if fabric.has_key?(key)
                count = fabric[key][:count] += 1
                if count == 2
                    result1 += 1
                    conflicts.add(fabric[key][:first])
                end
                conflicts.add(claim)
            else
                fabric[key] = {:first => claim, :count => 1}
            end
        end
    end
    conflicts.each {|claim| claims.delete(claim)}
end
result2 = claims.to_a[0]

puts "Part 1: #{result1} (#{result1 == 111935 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{result2} (#{result2 == 650 ? 'correct' : 'incorrect!'})"
