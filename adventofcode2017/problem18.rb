input = ""
File.open("input18.txt", 'r') {|f| input = f.read}

def value(x, registers)
    if x.match(/[a-z]/)
        registers[x] = 0 if !registers.has_key?(x)
        return registers[x]
    end
    return x.to_i
end
class Program
    def initialize(programID, instructions, receive_queue, send_queue)
        @current_instruction = 0
        @registers = {"p" => programID}
        @instructions = instructions
        @receive_queue = receive_queue
        @send_queue = send_queue
        @waiting = false
        @finished = false
        @sent = 0
        @ID = programID
    end
    def waiting?()
        @waiting
    end
    def finished?()
        @finished
    end
    def sent()
        @sent
    end
    def run(mode = 2)
        while @current_instruction >= 0 && @current_instruction <= @instructions.count
            instruction, arg1, arg2 = @instructions[@current_instruction].match(/(...) ([^ ]+) ?([^ ]+)?/).captures
            if instruction == "snd"
                @send_queue << value(arg1, @registers)
                @sent += 1
            elsif instruction == "set"
                @registers[arg1] = value(arg2, @registers)
            elsif instruction == "add"
                @registers[arg1] = value(arg1, @registers) + value(arg2, @registers)
            elsif instruction == "mul"
                @registers[arg1] = value(arg1, @registers) * value(arg2, @registers)
            elsif instruction == "mod"
                @registers[arg1] = value(arg1, @registers) % value(arg2, @registers)
            elsif instruction == "rcv"
                return @send_queue[@send_queue.count-1] if mode == 1 && value(arg1, @registers) != 0
                if @receive_queue.count > 0
                    @waiting = false
                    @registers[arg1] = @receive_queue.delete_at(0)
                else
                    @waiting = true
                    return
                end
            end
            @current_instruction += 1
            @current_instruction = @current_instruction - 1 + value(arg2, @registers) if instruction == "jgz" && value(arg1, @registers) > 0
        end
        @finished = true
    end
end
result1, result2, instructions, current_instruction, last_played, registers, my_queue, queue0, queue1 = 0, 0, input.split(/\n/), 0, nil, {}, [], [], []
program = Program.new(0, instructions, my_queue, my_queue)
result1, program0, program1 = program.run(1), Program.new(0, instructions, queue0, queue1), Program.new(1, instructions, queue1, queue0)
while !(program0.finished? && program1.finished? || (queue0.count == 0 && program0.waiting? && queue1.count == 0 && program1.waiting?) || (queue0.count == 0 && program0.waiting? && program1.finished?) || (program0.finished? && queue1.count == 0 && program1.waiting?))
    program0.run
    program1.run
end
result2 = program1.sent

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
