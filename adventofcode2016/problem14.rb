input = ""
File.open("input14.txt", 'r') {|f| input = f.read}

require 'digest'
def do_process(input, part2 = false)
    i, keys, valid_keys = 0, [], []
    while valid_keys.count < 64 || i < valid_keys[63] + 1000
        digest = Digest::MD5.hexdigest "#{input}#{i}"
        2016.times {digest = Digest::MD5.hexdigest digest} if part2
        if digest =~ /(.)\1\1\1\1/
            character = digest.match(/(.)\1\1\1\1/).captures[0]
            keys.delete_if{|key| i > key[0] + 1000}.each do |key|
                if key[1] == character
                    valid_keys << key[0]
                    key[0] = -1000
                end
            end
            valid_keys.sort!
        end
        keys << [i, digest.match(/(.)\1\1/).captures[0]] if digest =~ /(.)\1\1/
        i += 1
    end
    return valid_keys[63]
end

puts "Part 1: #{do_process(input)}"
puts "Part 2: #{do_process(input, true)}"
