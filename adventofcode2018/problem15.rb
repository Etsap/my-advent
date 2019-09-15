def adjacent?(grid, x, y, enemy)
    return grid[y][x-1] == enemy || grid[y][x+1] == enemy || grid[y-1][x] == enemy || grid[y+1][x] == enemy
end
def add_step!(grid, steps, x, y, firstx, firsty)
    steps << [x, y, firstx, firsty] if grid[y][x] == "." && nil == steps.index {|step| step[0] == x && step[1] == y}
end
def add_enemy!(grid, x, y, enemy, enemies, units)
    if grid[y][x] == enemy
        enemies << units[units.index {|u| u[:x] == x && u[:y] == y}]
    end
end
def do_simulation(elf_attack)
    input = ""
    File.open("input15.txt", 'r') {|f| input = f.read}
    grid, units, round, done = [], [], 0, false
    input.split(/\n/).each do |line|
        row = line.split(//)
        row.each_index do |i|
            square = row[i]
            if square == "E" || square == "G"
                enemy = "G"
                enemy = "E" if square == "G"
                attack = 3
                attack = elf_attack if square == "E"
                units << {:type => square, :hp => 200, :x => i, :y => grid.count, :enemy => enemy, :attack => attack}
            end
        end
        grid << row
    end
    while !done
        units.sort_by! {|a, b| [a[:y], a[:x]]}
        ui = 0
        while ui < units.count
            unit = units[ui]
            if nil == units.index{|e| e[:type] == unit[:enemy]}
                done = true
                break
            end
            unless adjacent?(grid, unit[:x], unit[:y], unit[:enemy])
                steps = []
                steps << [unit[:x], unit[:y]-1, unit[:x], unit[:y]-1] if grid[unit[:y]-1][unit[:x]] == "."
                steps << [unit[:x]-1, unit[:y], unit[:x]-1, unit[:y]] if grid[unit[:y]][unit[:x]-1] == "."
                steps << [unit[:x]+1, unit[:y], unit[:x]+1, unit[:y]] if grid[unit[:y]][unit[:x]+1] == "."
                steps << [unit[:x], unit[:y]+1, unit[:x], unit[:y]+1] if grid[unit[:y]+1][unit[:x]] == "."
                steps << [0, 0, 0, 0]
                i = 0
                keep_going = true
                valid_paths = []
                while i < steps.count
                    x, y, firstx, firsty = steps[i]
                    if x == 0
                        steps << [0, 0, 0, 0] unless i + 1 == steps.count
                        i = steps.count unless keep_going
                    elsif adjacent?(grid, x, y, unit[:enemy])
                        valid_paths << {:firstx => firstx, :firsty => firsty, :lastx => x, :lasty => y}
                        keep_going = false
                    elsif keep_going
                        add_step!(grid, steps, x, y-1, firstx, firsty)
                        add_step!(grid, steps, x-1, y, firstx, firsty)
                        add_step!(grid, steps, x+1, y, firstx, firsty)
                        add_step!(grid, steps, x, y+1, firstx, firsty)
                    end
                    i += 1
                end
                if valid_paths.count > 0
                    valid_paths.sort_by! {|a, b| [a[:lasty], a[:lastx]]}
                    grid[unit[:y]][unit[:x]] = "."
                    unit[:x] = valid_paths[0][:firstx]
                    unit[:y] = valid_paths[0][:firsty]
                    grid[unit[:y]][unit[:x]] = unit[:type]
                end
            end
            if adjacent?(grid, unit[:x], unit[:y], unit[:enemy])
                enemies = []
                add_enemy!(grid, unit[:x], unit[:y]-1, unit[:enemy], enemies, units)
                add_enemy!(grid, unit[:x]-1, unit[:y], unit[:enemy], enemies, units)
                add_enemy!(grid, unit[:x]+1, unit[:y], unit[:enemy], enemies, units)
                add_enemy!(grid, unit[:x], unit[:y]+1, unit[:enemy], enemies, units)
                enemies.sort_by! {|a, b| [a[:hp], a[:y], a[:x]]}
                enemies[0][:hp] -= unit[:attack]
                if enemies[0][:hp] <= 0
                    grid[enemies[0][:y]][enemies[0][:x]] = "."
                    ei = units.index {|enemy| enemy[:x] == enemies[0][:x] && enemy[:y] == enemies[0][:y]}
                    ui -= 1 if ei < ui
                    if enemies[0][:type] == "E" && elf_attack > 3
                        return nil
                    end
                    units.delete_at(ei)
                end
            end
            ui += 1
        end
        round += 1 unless done
    end
    sum = 0
    units.each {|unit| sum += unit[:hp]}
    return round * sum
end

part1 = do_simulation(3)
puts "Part 1: #{part1} (#{part1 == 189910 ? 'correct' : 'incorrect!'})"

i = 4
while nil == (part2 = do_simulation(i))
    i += 1
end

puts "Part 2: #{part2} (#{part2 == 57820 ? 'correct' : 'incorrect!'})"
