input = ""
File.open("input05.txt", 'r') {|f| input = f.read}

def getlength!(input, regexes)
    loop do
        found = nil
        regexes.each {|r| found |= input.gsub!(r, '')}
        return input.length unless found
    end
end
regexes = []
('a'..'z').each {|l| regexes << /(#{l}#{l.upcase}|#{l.upcase}#{l})/}
best = getlength!(input, regexes)
puts "Part 1: #{best} (#{best == 11590 ? 'correct' : 'incorrect!'})"

('a'..'z').each do |test|
    thisinput = input.gsub(/#{test}/i, '')
    thislength = getlength!(thisinput, regexes)
    best = thislength if thislength < best
end
puts "Part 2: #{best} (#{best == 4504 ? 'correct' : 'incorrect!'})"
