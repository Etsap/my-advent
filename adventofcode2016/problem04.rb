input = ""
File.open("input04.txt", 'r') {|f| input = f.read}

total = result = 0
input.scan(/([a-z-]*)-(\d+)\[([a-z]{5})\]/).each do |match|
    sums = {}
    match[0].gsub(/-/, '').split(//).each {|character| sums.has_key?(character) ? sums[character] += 1 : sums[character] = 1}
    reverses = []
    sums.each_key {|key| reverses[sums[key]] ? reverses[sums[key]] << key : reverses[sums[key]] = [key]}
    reverses.compact!.collect!{|list| list.sort}.reverse!
    if reverses.collect{|item| item.join}.join[0..4] == match[2]
        total += shift = match[1].to_i        
        room = ""
        match[0].split(//).each do |character|
            if character == "-"
                room += " "
            else
                nextord = (((character.ord - 96) + shift) % 26 + 96)
                room += nextord == 96 ? "z" : nextord.chr
            end
        end
        result = match[1] if room == "northpole object storage"
    end
end

puts "Part 1: #{total}"
puts "Part 2: #{result}"
