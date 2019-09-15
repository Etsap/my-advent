input = ""
File.open("input02.txt", 'r') {|f| input = f.read}

result1, twos, threes, result2, lines = 0, 0, 0, "", input.split(/\n/)
lines.each_with_index do |line, i|
    two = three = false
    ('a'..'z').each do |letter|
        count = line.count(letter)
        two = true if count == 2
        three = true if count == 3
        break if two && three
    end
    twos += 1 if two
    threes += 1 if three
    lines.slice(i+1..lines.size).each do |secondline|
        diffs, j, length = 0, 0, line.length
        while diffs < 2 && j < length
            diffs += 1 if line[j] != secondline[j]
            j += 1
        end
        if diffs == 1
            j = 0
            while j < length
                result2 += line[j] if line[j] == secondline[j]
                j+=1
            end
        end
    end
end
result1 = twos * threes

puts "Part 1: #{result1} (#{result1 == 5478 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{result2} (#{result2 == 'qyzphxoiseldjrntfygvdmanu' ? 'correct' : 'incorrect!'})"
