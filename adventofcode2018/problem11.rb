input = ""
File.open("input11.txt", 'r') {|f| input = f.read}

def computesum(grid, squaresize, x, y)
    if x > 0 && y > 0
        return grid[x+squaresize-1][y+squaresize-1] - grid[x-1][y+squaresize-1] - grid[x+squaresize-1][y-1] + grid[x-1][y-1]
    elsif y > 0
        return grid[x+squaresize-1][y+squaresize-1] - grid[x+squaresize-1][y-1]
    elsif x > 0
        return grid[x+squaresize-1][y+squaresize-1] - grid[x-1][y+squaresize-1]
    else
        return grid[x+squaresize-1][y+squaresize-1]
    end
end
def findbestsum(squaresize, grid)
    bestsum, limit, bestx, besty = -1.0 / 0, 300-squaresize, 0, 0
    for x in 0..limit
        for y in 0..limit
            sum = computesum(grid, squaresize, x, y)
            bestsum, bestx, besty = sum, x, y if sum > bestsum
        end
    end
    return bestx+1, besty+1, bestsum
end
grid_serial_number, grid, bestsize, bestx, besty, bestsum = input.to_i, [], 3, 0, 0, -1.0/0
for x in 0..299
    grid << []
    for y in 0..299
        rackID = x + 11
        powerLevel = (((rackID * (y + 1) + grid_serial_number) * rackID) % 1000) / 100 - 5
        if x > 0 && y > 0
            grid[x][y] = grid[x-1][y] + grid[x][y-1] - grid[x-1][y-1] + powerLevel
        elsif y > 0
            grid[x][y] = grid[x][y-1] + powerLevel
        elsif x > 0
            grid[x][y] = grid[x-1][y] + powerLevel
        else
            grid[0][0] = powerLevel
        end
    end
end
for squaresize in 1..300
    x, y, sum = findbestsum(squaresize, grid)
    puts "Part 1: #{x},#{y} (#{x == 235 && y == 63 ? 'correct' : 'incorrect!'})" if squaresize == 3
    bestsum, bestx, besty, bestsize = sum, x, y, squaresize if sum >= bestsum
end
puts "Part 2: #{bestx},#{besty},#{bestsize} (#{bestx == 229 && besty == 251 && bestsize == 16 ? 'correct' : 'incorrect!'})"
