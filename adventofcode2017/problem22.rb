input = ""
File.open("input22.txt", 'r') {|f| input = f.read}

result1, result2, row, column, direction, input_lines, grid, $up, $right, $down, $left, state = 0, 0, 0, 0, {:row => -1, :column => 0}, input.split(/\n/), [], {:row => -1, :column => 0}, {:row => 0, :column => 1}, {:row => 1, :column => 0}, {:row => 0, :column => -1}, {}
def turn_right(direction)
    if direction[:row] == -1
        return $right
    elsif direction[:column] == 1
        return $down
    elsif direction[:row] == 1
        return $left
    else
        return $up
    end
end
def turn_left(direction)
    if direction[:row] == -1
        return $left
    elsif direction[:column] == -1
        return $down
    elsif direction[:row] == 1
        return $right
    else
        return $up
    end
end
size = input_lines.count / 2
(-size..size).each {|row| (-size..size).each {|column| grid << [row, column] if (input_lines[row+size][column+size] == "#")}}
grid.each{|item| state["#{item[0]},#{item[1]}"] = :Infected}
10000.times do
    if grid.delete([row, column])
        direction = turn_right(direction)
    else
        direction = turn_left(direction)
        result1 += 1
        grid << [row, column]
    end
    row, column = row + direction[:row], column + direction[:column]
end
row, column, direction = 0, 0, $up
10000000.times do
    key = "#{row},#{column}"
    value = state[key]
    if value == nil
        direction = turn_left(direction)
        state[key] = :Weakened
    elsif value == :Infected
        direction = turn_right(direction)
        state[key] = :Flagged
    elsif value == :Flagged
        direction = {:row => -direction[:row], :column => -direction[:column]}
        state.delete(key)
    else
        result2 += 1
        state[key] = :Infected
    end
    row, column = row + direction[:row], column + direction[:column]
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
