input = ""
File.open("input13.txt", 'r') {|f| input = f.read}

def perform_loop(map, carts, part2 = false)
    loop do
        i, count = 0, carts.count
        while i < carts.length
            cart = carts[i]
            cart[:x] += cart[:dx]
            cart[:y] += cart[:dy]
            character = map[cart[:y]][cart[:x]]
            if character == "\\"
                cart[:dx], cart[:dy] = cart[:dy], cart[:dx]
            elsif character == "/"
                cart[:dx], cart[:dy] = -cart[:dy], -cart[:dx]
            elsif character == "+"
                if cart[:turn] == 0
                    cart[:turn] = 1
                else
                    td = cart[:turn]
                    cart[:dx], cart[:dy] = cart[:dy] * -td, cart[:dx] * td
                    cart[:turn] = -((td + 1) >> 1)
                end
            end
            x, y = cart[:x], cart[:y]
            j = (0..carts.count-1).find{|j| i != j && x == carts[j][:x] && y == carts[j][:y]}
            if part2 && j != nil
                if i > j
                    carts.delete_at(i)
                    carts.delete_at(j)
                    i -= 1
                else
                    carts.delete_at(j)
                    carts.delete_at(i)
                end
            else
                return x, y if j != nil
                i += 1
            end
        end
        if carts.count == 1
            return carts[0][:x], carts[0][:y]
        end
        carts.sort_by! {|a, b| [a[:y], a[:x]]}
    end
end
map, carts, carts2 = [], [], []
input.split(/\n/).each do |line|
    map << line
    for x in 0..line.length-1
        character = line[x]
        if character == "<"
            carts << {:x => x, :y => map.count-1, :dx => -1, :dy => 0, :turn => -1}
            carts2 << {:x => x, :y => map.count-1, :dx => -1, :dy => 0, :turn => -1}
            map[-1][x] = "-"
        elsif character == ">"
            carts << {:x => x, :y => map.count-1, :dx => 1, :dy => 0, :turn => -1}
            carts2 << {:x => x, :y => map.count-1, :dx => 1, :dy => 0, :turn => -1}
            map[-1][x] = "-"
        elsif character == "^"
            carts << {:x => x, :y => map.count-1, :dx => 0, :dy => -1, :turn => -1}
            carts2 << {:x => x, :y => map.count-1, :dx => 0, :dy => -1, :turn => -1}
            map[-1][x] = "|"
        elsif character == "v"
            carts << {:x => x, :y => map.count-1, :dx => 0, :dy => 1, :turn => -1}
            carts2 << {:x => x, :y => map.count-1, :dx => 0, :dy => 1, :turn => -1}
            map[-1][x] = "|"
        end
    end
end
x, y = perform_loop(map, carts)
puts "Part 1: #{x},#{y} (#{x == 143 && y == 43 ? 'correct' : 'incorrect!'})"
x, y = perform_loop(map, carts2, true)
puts "Part 2: #{x},#{y} (#{x == 116 && y == 125 ? 'correct' : 'incorrect!'})"
