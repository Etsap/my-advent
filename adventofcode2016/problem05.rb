input = ""
File.open("input05.txt", 'r') {|f| input = f.read}

require 'digest'
i = 0
result1 = ""
result2 = "        "
while result2 =~ / /
    digest = Digest::MD5.hexdigest "#{input}#{i}"
    if match = digest.match(/^00000(.)/)
        result1 += match.captures[0] if result1.length < 8
        result2[match.captures[0].to_i] = digest[6] if match.captures[0] < "8" && result2[match.captures[0].to_i] == " "
    end
    i += 1
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
