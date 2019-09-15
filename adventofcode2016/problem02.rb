input = ""
File.open("input02.txt", 'r') {|f| input = f.read}

x1 = y1 = 1
keys1 = ["123","456","789"]
result1 = result2 = ""
x2 = 0
y2 = 2
keys2 = ["  1  "," 234 ","56789"," ABC ","  D  "]
input.split(/\s/).each do |line|
    line.split(//).each do |character|
        y1 -= 1 if character == "U" && y1 > 0
        y1 += 1 if character == "D" && y1 < 2
        x1 -= 1 if character == "L" && x1 > 0
        x1 += 1 if character == "R" && x1 < 2
        y2 -= 1 if character == "U" && (2-x2).abs + (3-y2).abs <= 2 #(2-x2).abs + (3-(y2-1)).abs
        y2 += 1 if character == "D" && (2-x2).abs + (1-y2).abs <= 2 #(2-x2).abs + (3-(y2+1)).abs
        x2 -= 1 if character == "L" && (3-x2).abs + (2-y2).abs <= 2 #(2-(x2-1)).abs + (3-y2).abs
        x2 += 1 if character == "R" && (1-x2).abs + (2-y2).abs <= 2 #(2-(x2+1)).abs + (3-y2).abs
    end
    result1 += keys1[y1][x1]
    result2 += keys2[y2][x2]
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
