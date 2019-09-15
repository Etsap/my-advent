input = ""
File.open("input18.txt", 'r') {|f| input = f.read}

def count_neighbors(map, i, j, target)
    count = 0
    if i > 0
        count += 1 if j > 0 && map[i-1][j-1] == target
        count += 1 if map[i-1][j] == target
        count += 1 if j < 49 && map[i-1][j+1] == target
    end
    count += 1 if j > 0 && map[i][j-1] == target
    count += 1 if j < 49 && map[i][j+1] == target
    if i < 49
        count += 1 if j > 0 && map[i+1][j-1] == target
        count += 1 if map[i+1][j] == target
        count += 1 if j < 49 && map[i+1][j+1] == target
    end
    return count
end
def do_iteration(map)
    new_map, score_wood, score_ly = [], 0, 0
    map.each_index do |i|
        new_row = []
        map[i].each_index do |j|
            acre = map[i][j]
            if acre == "|"
                if count_neighbors(map, i, j, "#") >= 3
                    new_row << "#"
                    score_ly += 1
                else
                    new_row << "|"
                    score_wood += 1
                end
            else
                trees = count_neighbors(map, i, j, "|")
                if acre == "."
                    if trees >= 3
                        new_row << "|"
                        score_wood += 1
                    else
                        new_row << "."
                    end
                else
                    if trees >= 1 && count_neighbors(map, i, j, "#") >= 1
                        new_row << "#"
                        score_ly += 1
                    else
                        new_row << "."
                    end
                end
            end
        end
        new_map << new_row
    end
    return new_map, score_wood * score_ly
end
map = input.split(/\n/)
map = map.collect{|row| row.split('')}
scores = []
10.times do
    map, score = do_iteration(map)
    scores << score
end
puts "Part 1: #{scores[-1]} (#{scores[-1] == 507755 ? 'correct' : 'incorrect!'})"

repetition, ri, part2 = nil, 0, nil
(1000000000 - 10).times do
    map, score = do_iteration(map)
    if scores.include?(score)
        if repetition
            if score == repetition[ri]
                ri += 1
                if ri == repetition.count
                    scores << score << repetition[0]
                    part2 = repetition[(1000000000 - scores.count) % repetition.count]
                    break
                end
            else
                repetition = nil
            end
        else
            repetition = scores[-scores.reverse.index(score)-1..-1]
            ri = 1
        end
    end
    scores << score
end
puts "Part 2: #{part2} (#{part2 == 235080 ? 'correct' : 'incorrect!'})"