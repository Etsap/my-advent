input = ""
File.open("input05.txt", 'r') {|f| input = f.read}

puts "Part 1: #{input.split(/\n/).count{|string| string =~ /[aeiou].*[aeiou].*[aeiou]/ && string =~ /(.)\1/ && !(string =~ /(ab|cd|pq|xy)/)}}"
puts "Part 2: #{input.split(/\n/).count{|string| string =~ /(..).*\1/ && string =~ /(.).\1/}}"
