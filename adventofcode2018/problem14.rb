input = ""
File.open("input14.txt", 'r') {|f| input = f.read}

def do_iteration(recipes, elf1, elf2)
    recipe1, recipe2 = recipes[elf1], recipes[elf2]
    sum = recipe1 + recipe2
    if sum > 9
        recipes << 1 << sum-10
    else
        recipes << sum
    end
    elf1 += recipe1 + 1
    elf2 += recipe2 + 1
    count = recipes.count
    while elf1 >= count
        elf1 -= count
    end
    while elf2 >= count
        elf2 -= count
    end
    return elf1, elf2
end
inputi, recipes, elf1, elf2, part1, part2 = input.to_i, [3, 7], 0, 1, nil, nil
input1, input2, input3, input4, input5, input6 = input[-6..-1].reverse.split('').collect{|x| x.to_i} # hard-coded length
while part1 == nil || part2 == nil
    elf1, elf2 = do_iteration(recipes, elf1, elf2)
    if part1 == nil && recipes.count >= inputi + 10
        part1 = recipes[-10..-1].collect {|x| x.to_s}.join
    end
    if part2 == nil
        if recipes[-1] == input1 && recipes[-2] == input2 && recipes[-3] == input3 && recipes[-4] == input4 && recipes[-5] == input5 && recipes[-6] == input6
            part2 = recipes.count - 6 # hard-coded
        elsif recipes[-2] == input1 && recipes[-3] == input2 && recipes[-4] == input3 && recipes[-5] == input4 && recipes[-6] == input5 && recipes[-7] == input6
            part2 = recipes.count - 7 # hard-coded
        end
    end
end

puts "Part 1: #{part1} (#{part1 == '5482326119' ? 'correct' : 'incorrect!'})"
puts "Part 2: #{part2} (#{part2 == 20368140 ? 'correct' : 'incorrect!'})"
