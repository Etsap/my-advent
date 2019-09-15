input = ""
File.open("input04.txt", 'r') {|f| input = f.read}

result1 = result2 = 0
input.split(/\n/).each do |phrase|
    words = phrase.split(/\s+/)
    result1 += 1 if words.count == words.uniq.count
    words = words.collect{|word| word.chars.sort.join}
    result2 += 1 if words.count == words.uniq.count
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
