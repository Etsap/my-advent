input = ""
File.open("input17.txt", 'r') {|f| input = f.read}

require 'digest'
unvisited = [[0,0,""]]
def process_path!(input, unvisited)
    x, y, path = unvisited.delete_at(0)
    digest = Digest::MD5.hexdigest "#{input}#{path}"
    unvisited << [x, y-1, path + "U"] if y > 0 && digest[0] > 'a' && digest[0] < 'g' && (x != 3 || y != 3)
    unvisited << [x, y+1, path + "D"] if y < 3 && digest[1] > 'a' && digest[1] < 'g'
    unvisited << [x-1, y, path + "L"] if x > 0 && digest[2] > 'a' && digest[2] < 'g' && (x != 3 || y != 3)
    unvisited << [x+1, y, path + "R"] if x < 3 && digest[3] > 'a' && digest[3] < 'g'
    return x, y, path
end
x, y, shortest_path = process_path!(input, unvisited) while x != 3 || y != 3
begin
    x, y, path = process_path!(input, unvisited)
    longest_path = path if x == 3 && y == 3
end while unvisited.count > 0

puts "Part 1: #{shortest_path}"
puts "Part 2: #{longest_path.length}"
