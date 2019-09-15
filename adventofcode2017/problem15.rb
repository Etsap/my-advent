input = ""
File.open("input15.txt", 'r') {|f| input = f.read}

result1, result2, generators, divisor, generators_copy = 0, 0, {:A => {:value => input.match(/Generator A starts with (\d+)/).captures[0].to_i, :factor => 16807, :criteria => 4}, :B => {:value => input.match(/Generator B starts with (\d+)/).captures[0].to_i, :factor => 48271, :criteria => 8}}, 2147483647, {}
generators.each_pair{|key, generator| generators_copy[key] = generator.clone}
40000000.times do
    generators.each_value {|generator| generator[:value] = generator[:value] * generator[:factor] % divisor}
    result1 += 1 if (generators[:A][:value]) & 65535 == (generators[:B][:value] & 65535)
end
5000000.times do
    generators_copy.each_value do |generator|
        begin
            generator[:value] = generator[:value] * generator[:factor] % divisor
        end while generator[:value] % generator[:criteria] != 0
    end
    result2 += 1 if (generators_copy[:A][:value]) & 65535 == (generators_copy[:B][:value] & 65535)
end

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
