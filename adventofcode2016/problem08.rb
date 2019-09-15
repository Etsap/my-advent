input = ""
File.open("input08.txt", 'r') {|f| input = f.read}

screen, result1 = [[],[],[],[],[],[]], 0
(0..5).each {|i| (0..49).each {|x| screen[i] << false}}
def move(i, j, previous, screen)
    current = screen[i][j]
    screen[i][j] = previous
    return current
end
input.split(/\n/).each do |line|
    if line =~ /^rect/
        x, y = line.match(/rect (\d+)x(\d+)/).captures
        (0..y.to_i-1).each {|i| (0..x.to_i-1).each {|j| screen[i][j] = true}}
    else # line =~ /^rotate/
        object, index, amount = line.match(/rotate (row y|column x)=(\d+) by (\d+)/).captures
        amount.to_i.times do
            if object == "column x"
                previous, index = screen[5][index.to_i], index.to_i
                (0..5).each {|i| previous = move(i, index, previous, screen)}
            else # object == "row y"
                previous, index = screen[index.to_i][49], index.to_i
                (0..49).each {|i| previous = move(index, i, previous, screen)}
            end
        end
    end
end
screen.each {|row| result1 += row.count{|x| x}}
result2 = screen.collect{|row| row.collect{|x| x ? "#" : "."}.join}.join("\n")

puts "Part 1: #{result1}"
puts "Part 2: \n#{result2}"
