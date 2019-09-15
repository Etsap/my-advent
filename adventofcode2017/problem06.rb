input = ""
File.open("input06.txt", 'r') {|f| input = f.read}

result1, result2 = 0, 0
visited, content = [], input.split(/\s+/).collect{|item| item.to_i}
begin
    visited << content.join(",")
    highest = 0
    (1..content.count-1).each {|i| highest = i if content[i] > content[highest]}
    redistribute, content[highest], i = content[highest], 0, highest
    redistribute.times do
        i = i+1 == content.count ? 0 : i + 1
        content[i] += 1
    end
    result1 += 1
end while !visited.index(content.join(","))
result2 = result1 - visited.index(content.join(","))

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
