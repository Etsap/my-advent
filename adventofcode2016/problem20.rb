input = ""
File.open("input20.txt", 'r') {|f| input = f.read}

matches = input.scan(/(\d+)-(\d+)/).collect{|m| [m[0].to_i, m[1].to_i]}
matches.sort!{|a,b| a[0] <=> b[0]}
answer = nil
total = current = 0
matches.each do |match|
    current = match[1] + 1 if current >= match[0] && current <= match[1]
    if current < match[0]
        total += match[0] - current
        answer = current unless answer
        current = match[1] + 1
    end
end
total += 4294967295 - current if current < 4294967295

puts "Part 1: #{answer}"
puts "Part 2: #{total}"
