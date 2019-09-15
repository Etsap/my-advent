input = ""
File.open("input04.txt", 'r') {|f| input = f.read}

entries, guards = {}, {}
input.scan(/\[(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)\] (.*)/).each do |entry|
    year, month, day, hour, minute, text = entry[0..5]
    entries[year+month+day+hour+minute] = text
end
sleep, best, guard, max_sleeper = "", 0, nil, nil
entries.keys.sort.each do |key|
    entry = entries[key]
    if match = /Guard #(\d+) begins shift/.match(entry)
        guard = match.captures[0]
        max_sleeper = guard unless max_sleeper
        unless guards.has_key?(guard)
            guards[guard] = {:total => 0, :minutes => [0] * 60}
        end
    elsif entry == "falls asleep"
        sleep = key[-2..-1].to_i
    else
        wake = key[-2..-1].to_i
        guards[guard][:total] += wake - sleep
        max_sleeper = guard if guards[guard][:total] > guards[max_sleeper][:total]
        for i in sleep..wake-1
            guards[guard][:minutes][i] += 1
        end
    end
end
guards[max_sleeper][:minutes].each_index do |minute|
    best = minute if guards[max_sleeper][:minutes][minute] > guards[max_sleeper][:minutes][best]
end

result1 = max_sleeper.to_i * best
puts "Part 1: #{result1} (#{result1 == 21083 ? 'correct' : 'incorrect!'})"

best_count, best_score = 0, 0
guards.each_key do |guard|
    guards[guard][:minutes].each_index do |minute|
        count = guards[guard][:minutes][minute]
        best_count, best_score = count, guard.to_i * minute if count > best_count
    end
end

result2 = best_score
puts "Part 2: #{result2} (#{result2 == 53024 ? 'correct' : 'incorrect!'})"
