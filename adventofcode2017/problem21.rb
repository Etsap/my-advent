input = ""
File.open("input21.txt", 'r') {|f| input = f.read}

def rotate_and_add(rules, match, result)
    4.times do
        if match.length == 5
            match = match[3] + match[0] + '/' + match[4] + match[1]
        else
            match = match[8] + match[4] + match[0] + '/' + match[9] + match[5] + match[1] + '/' + match[10] + match[6] + match[2]
        end
        rules[match] = result
    end
end
def do_iteration(grid, rules)
    size, result = grid.count, []
    if size % 2 == 0
        i, j, result = 0, 0, Array.new(size / 2 * 3){""}
        while i < size
            k = 0
            while k < size
                mini_result = rules[grid[i][k..k+1] + "/" + grid[i+1][k..k+1]]
                result[j] += mini_result[0]
                result[j+1] += mini_result[1]
                result[j+2] += mini_result[2]
                k += 2
            end
            i += 2
            j += 3
        end
    else
        i, j, result = 0, 0, Array.new(size / 3 * 4){""}
        while i < size
            k = 0
            while k < size
                mini_result = rules[grid[i][k..k+2] + "/" + grid[i+1][k..k+2] + "/" + grid[i+2][k..k+2]]
                result[j] += mini_result[0]
                result[j+1] += mini_result[1]
                result[j+2] += mini_result[2]
                result[j+3] += mini_result[3]
                k += 3
            end
            i += 3
            j += 4
        end
    end
    return result
end
result1, result2, grid, rules = 0, 0, [".#.","..#","###"], {}
input.split(/\n/).each do |line|
    match, result = line.match(/(.*) => (.*)/).captures
    result = result.split(/\//)
    rotate_and_add(rules, match, result)
    if match.length == 5
        match = match[1] + match[0] + '/' + match[4] + match[3]
    else
        match = match[0..2].reverse() + '/' + match[4..6].reverse() + '/' + match[8..10].reverse()
    end
    rotate_and_add(rules, match, result)
end
5.times do
    grid = do_iteration(grid, rules)
end
grid.each {|row| result1 += row.count("#")}
13.times do
    grid = do_iteration(grid, rules)
end
grid.each {|row| result2 += row.count("#")}

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
