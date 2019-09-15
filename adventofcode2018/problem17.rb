input = ""
File.open("input17.txt", 'r') {|f| input = f.read}

miny, maxy, grid, water_endpoints, water_count, retained_count = 1.0 / 0, 0, {}, [[500, 0]], 0, 0
input.scan(/(.)=(\d+), (.)=(\d+)..(\d+)/).each do |vein|
    a, b, c, d, e = vein[0], vein[1].to_i, vein[2], vein[3].to_i, vein[4].to_i
    if a == "y"
        y, x1, x2 = b, d, e
        miny = y if y < miny
        maxy = y if y > maxy
        for x in x1..x2
            grid["#{x},#{y}"] = "#"
        end
    else
        x, y1, y2 = b, d, e
        miny = y1 if y1 < miny
        maxy = y2 if y2 > maxy
        for y in y1..y2
            grid["#{x},#{y}"] = "#"
        end
    end
end
water_count = 1 if miny <= 0
while water_endpoints.count > 0
    x, y = water_endpoints.pop
    if y < maxy && !grid.has_key?("#{x},#{y+1}")
        grid["#{x},#{y+1}"] = "|"
        water_endpoints << [x, y+1]
        water_count += 1 if y+1 >= miny
    elsif y < maxy && (grid["#{x},#{y+1}"] == "#" || grid["#{x},#{y+1}"] == "~")
        xl, xr = x-1, x+1
        xl -= 1 while (grid["#{xl},#{y+1}"] == "#" || grid["#{xl},#{y+1}"] == "~") && (!grid.has_key?("#{xl},#{y}") || grid["#{xl},#{y}"] == "|")
        xr += 1 while (grid["#{xr},#{y+1}"] == "#" || grid["#{xr},#{y+1}"] == "~") && (!grid.has_key?("#{xr},#{y}") || grid["#{xr},#{y}"] == "|")
        if grid["#{xl},#{y}"] == "#" && grid["#{xr},#{y}"] == "#"
            for xp in xl+1..xr-1
                water_count += 1 if grid["#{xp},#{y}"] != "|"
                retained_count += 1
                grid["#{xp},#{y}"] = "~"
                water_endpoints << [xp, y-1] if grid["#{xp},#{y-1}"] == "|"
            end
        else
            for xp in xl+1..xr-1
                water_count += 1 if grid["#{xp},#{y}"] != "|"
                grid["#{xp},#{y}"] = "|"
            end
            if grid["#{xl},#{y}"] != "#" && grid["#{xl},#{y}"] != "|"
                grid["#{xl},#{y}"] = "|"
                water_endpoints << [xl, y]
                water_count += 1
            end
            if grid["#{xr},#{y}"] != "#" && grid["#{xr},#{y}"] != "|"
                grid["#{xr},#{y}"] = "|"
                water_endpoints << [xr, y]
                water_count += 1
            end
        end
    end
end
puts "Part 1: #{water_count} (#{water_count == 39649 ? 'correct' : 'incorrect!'})"
puts "Part 2: #{retained_count} (#{retained_count == 28872 ? 'correct' : 'incorrect!'})"
