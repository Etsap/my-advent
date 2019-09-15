input = ""
File.open("input20.txt", 'r') {|f| input = f.read}

threshold = input.to_i
def find_house(threshold, count_presents)
	house, stop, stopsquared = 0, 1, 1
	while true
		house += 1
		if house > stopsquared
			stop += 1
			stopsquared = stop * stop
		end
		presents = 0
		(1..stop).each {|elf| presents += count_presents.call(house, elf) if house % elf == 0}
		return house if presents >= threshold
	end
end
count_presents = Proc.new{|house, elf|
	elf2 = house / elf
	elf += elf2 if elf != elf2
	10 * elf
}
puts "Part 1: #{find_house(threshold, count_presents)}"

count_presents = Proc.new{|house, elf|
	elf2 = house / elf
	elf2 = 0 if elf == elf2 || house > 50 * elf2
	elf = 0 if house > 50 * elf
	11 * (elf + elf2)
}
puts "Part 2: #{find_house(threshold, count_presents)}"
