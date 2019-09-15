input = ""
File.open("input03.txt", 'r') {|f| input = f.read}

def valid(triangle) # triangle has been converted to integers and sorted.
    return triangle[0] + triangle[1] > triangle[2]
end
total1 = total2 = 0
input.scan(/\s*(\d+)\s+(\d+)\s+(\d+)/).each {|match| total1 += 1 if valid([match[0].to_i, match[1].to_i, match[2].to_i].sort)}
input.scan(/\s*(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/).each do |match|
    total2 += 1 if valid([match[0].to_i, match[3].to_i, match[6].to_i].sort)
    total2 += 1 if valid([match[1].to_i, match[4].to_i, match[7].to_i].sort)
    total2 += 1 if valid([match[2].to_i, match[5].to_i, match[8].to_i].sort)
end

puts "Part 1: #{total1}"
puts "Part 2: #{total2}"
