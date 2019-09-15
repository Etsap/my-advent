input = ""
File.open("input09.txt", 'r') {|f| input = f.read}

players, final_marble = /(\d+) .* (\d+)/.match(input).captures.collect{|x| x.to_i}
def solve(players, final_marble)
    elves, circle, next_circle, current_marble, player, marble = [0] * players, [0], [], 0, 0, 1
    while marble <= final_marble
        player += 1
        player -= players if player >= players
        if marble % 23 == 0
            score = marble
            if next_circle.count >= 8
                score += next_circle.delete_at(-8)
                elves[player] += score
                next_circle.insert(-6, marble += 1)
                next_circle.insert(-5, marble += 1)
                next_circle.insert(-4, marble += 1)
                next_circle.insert(-3, marble += 1)
                next_circle.insert(-2, marble += 1)
                next_circle << marble += 1
                player += 6
            else
                circle = next_circle + circle[current_marble..-1]
                current_marble = circle.count - 8 + next_circle.count
                score += circle.delete_at(current_marble)
                elves[player] += score
                while current_marble + 1 < circle.count
                    current_marble += 2
                    circle.insert(current_marble, marble += 1)
                    player += 1
                end
                next_circle = []
                current_marble = 0
            end
        else
            next_circle << circle[current_marble]
            next_circle << marble
            current_marble += 1
            if current_marble == circle.count
                circle = next_circle
                next_circle = []
                current_marble = 0
            end
        end
        marble += 1
    end
    return elves.sort[-1]
end

part1 = solve(players, final_marble)
puts "Part 1: #{part1} (#{part1 == 370210 ? 'correct' : 'incorrect!'})"
part2 = solve(players, final_marble * 100)
puts "Part 2: #{part2} (#{part2 == 3101176548 ? 'correct' : 'incorrect!'})"
