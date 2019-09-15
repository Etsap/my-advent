input = ""
File.open("input06.txt", 'r') {|f| input = f.read}

counter = [{}, {}, {}, {}, {}, {}, {}, {}]
input.split(/\s+/).each do |line|
    (0..7).each do |i|
        counter[i].has_key?(line[i]) ? counter[i][line[i]] += 1 : counter[i][line[i]] = 1
    end
end
result1 = result2 = ""
(0..7).each do |i|
    character1 = character2 = nil
    counter[i].each_key do |key|
        character1 = key if !character1 || counter[i][key] > counter[i][character1]
        character2 = key if !character2 || counter[i][key] < counter[i][character2]
    end
    result1 += character1
    result2 += character2
end


puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
