input = ""
File.open("input21.txt", 'r') {|f| input = f.read}

def rotate(password, steps)
    return password.slice(password.length-steps..password.length-1) + password.slice(0..password.length-steps-1) if steps > 0
    return password.slice(-steps..password.length-1) + (steps < 0 ? password.slice(0..-steps-1) : "")
end
def process_instruction(instruction, password, reverse = false)
    if match = instruction.match(/rotate left (\d+) steps?/)
        return rotate(password, (reverse ? 1 : -1)*(match.captures[0].to_i % password.length))
    elsif match = instruction.match(/rotate right (\d+) steps?/)
        return rotate(password, (reverse ? -1 : 1) * (match.captures[0].to_i % password.length))
    elsif match = instruction.match(/swap letter (.) with letter (.)/)
        return password.gsub(/#{match.captures[0]}/, '#').gsub(/#{match.captures[1]}/, match.captures[0]).gsub(/#/, match.captures[1])
    elsif match = instruction.match(/move position (\d+) to position (\d+)/)
        position1, position2 = match.captures.collect{|c| c.to_i}
        position1, position2 = position2, position1 if reverse
        return password.insert(position2.to_i, password.slice!(position1.to_i))
    elsif match = instruction.match(/swap position (\d+) with position (\d+)/)
        position1, position2 = match.captures.collect{|c| c.to_i}.sort
        return (position1 > 0 ? password.slice(0..position1-1) : "") + password.slice(position2) + (position1+1 < position2 ? password.slice(position1+1..position2-1) : "") + password.slice(position1) + (position2+1 < password.length ? password.slice(position2+1..password.length-1) : "")
    elsif match = instruction.match(/rotate based on position of letter (.)/)
        index = password.index(match.captures[0])
        if reverse && index % 2 == 1
            index = -(index + 1) / 2
        elsif reverse
            index = -(index / 2 + 5) if index > 0
            index = -1 if index == 0
        end
        index += index >= 4 ? 2 : 1 unless reverse
        return rotate(password, index % password.length)
    elsif match = instruction.match(/reverse positions (\d+) through (\d+)/)
        position1, position2 = match.captures.collect{|c| c.to_i}.sort
        return (position1 > 0 ? password.slice(0..position1-1) : "") + password.slice(position1..position2).reverse + (position2+1 < password.length ? password.slice(position2+1..password.length-1) : "")
    end
end
instructions = input.split(/\n/)
password = "abcdefgh"
instructions.each {|instruction| password = process_instruction(instruction, password)}

puts "Part 1: #{password}"

password = "fbgdceah"
instructions.reverse.each {|instruction| password = process_instruction(instruction, password, true)}

puts "Part 2: #{password}"
