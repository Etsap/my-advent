input = ""
File.open("input19.txt", 'r') {|f| input = f.read}

result1, result2, lines = "", 1, input.split(/\n/)
row, column, direction = 0, lines[0].index("|"), {:row => 1, :column => 0}
while true
    row, column, result2 = row + direction[:row], column + direction[:column], result2 + 1
    if lines[row][column].match(/[A-Z]/)
        result1 += lines[row][column]
        break if lines[row+direction[:row]][column+direction[:column]] == " "
    elsif lines[row][column] == "+"
        if direction[:row] != 0
            direction[:row] = 0
            if column > 0 && lines[row][column-1] != " "
                direction[:column] = -1
            elsif column < lines[row].length && lines[row][column+1] != " "
                direction[:column] = 1
            else
                break
            end
        else
            direction[:column] = 0
            if row > 0 && lines[row-1][column] != " "
                direction[:row] = -1
            elsif row < lines.count && lines[row+1][column] != " "
                direction[:row] = 1
            else
                break
            end
        end
    end
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
