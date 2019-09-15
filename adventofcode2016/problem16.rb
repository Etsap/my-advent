input = ""
File.open("input16.txt", 'r') {|f| input = f.read}

def checksum!(input)
    i = j = 0
    l = input.length / 2
    while j < l
        input[j] = input[i] == input[i+1] ? "1" : "0"
        j += 1
        i += 2
    end
    input.slice!(l, l)
end
def checksum2(input) # This whole section necessary because the pointer arithmetic in checksum! gets bad on long strings.
    slice_amount = 10000
    result = []
    while input.length > 0
        temp = input.slice!(0,slice_amount)
        checksum!(temp)
        result << temp
    end
    return result.join
end
def fill_disk(input, size)
    input = "#{input}0#{input.gsub(/1/, 'x').gsub(/0/, '1').gsub(/x/, '0').reverse}" while input.length < size
    input = input[0..size-1]
    begin
        #checksum!(input) #Doing this can work vs what is below - just not fast enough
        input = checksum2(input)
    end while input.length % 2 == 0
    return input
end

puts "Part 1: #{fill_disk(input, 272)}"
puts "Part 2: #{fill_disk(input, 35651584)}"
