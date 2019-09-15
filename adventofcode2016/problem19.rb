input = ""
File.open("input19.txt", 'r') {|f| input = f.read}

first, interval, count = 1, 1, input.to_i
while count > 1
    interval = interval<<1
    first += interval if count % 2 == 1
    count = count>>1
end
def eliminate(elves, turn, steal_from, odd)
    elves[steal_from] = nil
    return turn + 1, steal_from + 1 + odd, 1 - odd
end
count, turn, elves = input.to_i, 0, []
(1..count).each {|i| elves << i}
odd = count % 2
while count > 1
    steal_from = turn + count>>1
    turn, steal_from, odd = eliminate(elves, turn, steal_from, odd) while steal_from < count
    steal_from %= count
    elves.compact!
    count = elves.count
    turn, steal_from, odd = eliminate(elves, turn, steal_from, odd) while turn < count
    elves.compact!
    turn, count = 0, elves.count
end

puts "Part 1: #{first}"
puts "Part 2: #{elves[0]}"
