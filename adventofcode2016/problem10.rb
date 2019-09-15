input = ""
File.open("input10.txt", 'r') {|f| input = f.read}

bots, instructions, result, outputs = [], input.split(/\n/), nil, [nil, nil, nil]
while result == nil || outputs[0] == nil || outputs[1] == nil || outputs[2] == nil
    line = instructions.delete_at(0)
    if line =~ /^value/
        value, bot = line.match(/value (\d+) goes to bot (\d+)/).captures
        bots[bot.to_i] ? bots[bot.to_i] << value.to_i : bots[bot.to_i] = [value.to_i]
    else # line =~ /^bot/
        bot0, type1, bot1, type2, bot2 = line.match(/bot (\d+) gives low to (output|bot) (\d+) and high to (output|bot) (\d+)/).captures
        bot0, bot1, bot2 = bot0.to_i, bot1.to_i, bot2.to_i
        if bots[bot0] && bots[bot0].count == 2
            bots[bot0].sort!
            result = bot0 if bots[bot0][0] == 17 && bots[bot0][1] == 61
            if type1 == "bot"
                bots[bot1] ? bots[bot1] << bots[bot0][0] : bots[bot1] = [bots[bot0][0]]
            else
                outputs[bot1] = bots[bot0][0]
            end
            if type2 == "bot"
                bots[bot2] ? bots[bot2] << bots[bot0][1] : bots[bot2] = [bots[bot0][1]]
            else
                outputs[bot2] = bots[bot0][1]
            end
        else
            instructions << line
        end
    end
end

puts "Part 1: #{result}"
puts "Part 2: #{outputs[0] * outputs[1] * outputs[2]}"
