input = ""
File.open("input07.txt", 'r') {|f| input = f.read}

result1 = result2 = 0
input.split(/\s+/).each do |line|
    adjustedline = line.gsub(/(.)\1\1\1/, '\1+-\1')
    result1 += 1 if adjustedline.match(/(.)(.)\2\1/) && !(adjustedline =~ /\[[a-z]*(.)(.)\2\1[a-z]*\]/)
    adjustedline = line.gsub(/(.)\1\1/, '\1_\1')
    result2 += 1 if adjustedline.match(/(^|\])\w*(.)(.)\2.*\[\w*\3\2\3|\[\w*(.)(.)\4.*\]\w*\5\4\5/)
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
