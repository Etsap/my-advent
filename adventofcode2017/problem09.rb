input = ""
File.open("input09.txt", 'r') {|f| input = f.read}

result1, result2, nesting, removecancel = 0, 0, 0, input.gsub(/!./, '')
removecancel.gsub(/<.*?>/, '').gsub(/[^{}]/, '').chars.each do |character|
    if character == "{"
        nesting += 1
        result1 += nesting
    elsif character == "}"
        nesting -= 1
    end
end
removecancel.scan(/<.*?>/).each {|match| result2 += match.length - 2}

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
