input = ""
File.open("input18.txt", 'r') {|f| input = f.read}

def get_result(input, rows)
    current_row = input.split(//)
    total = 0
    rows.times do
        total += current_row.count{|x| x == '.'}
        next_row = []
        current_row.each_index {|i| next_row << ((i > 0 && current_row[i-1] == "^" && current_row[i] == "^" && current_row[i+1] != "^" || (i == 0 || current_row[i-1] != "^") && current_row[i] == "^" && current_row[i+1] == "^" || i > 0 && current_row[i-1] == "^" && current_row[i] != "^" && current_row[i+1] != "^" || (i == 0 || current_row[i-1] != "^") && current_row[i] != "^" && current_row[i+1] == "^") ? "^" : ".")}
        current_row = next_row
    end
    return total
end

puts "Part 1: #{get_result(input, 40)}"
puts "Part 2: #{get_result(input, 400000)}"
