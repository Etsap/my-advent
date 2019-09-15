input = ""
File.open("input20.txt", 'r') {|f| input = f.read}

def compute_distances(particles, distances)
    distances.each_key do |key|
        p1, p2 = key.match(/(\d+),(\d+)/).captures.collect{|c| c.to_i}
        if particles[p1] == nil || particles[p2] == nil
            distances.delete(key)
        else
            distance = 0
            (0..2).each {|i| distance += (particles[p1][:position][i] - particles[p2][:position][i]).abs}
            distances[key] = distance
        end
    end
end
result1, result2, particles, min_acceleration, distances = 0, 0, [], 0, {}
input.split(/\n/).each do |line|
    px, py, pz, vx, vy, vz, ax, ay, az = line.match(/p=<(-?\d+),(-?\d+),(-?\d+)>, v=<(-?\d+),(-?\d+),(-?\d+)>, a=<(-?\d+),(-?\d+),(-?\d+)>/).captures.collect{|c| c.to_i}
    particles << {:position => [px, py, pz], :velocity => [vx, vy, vz], :acceleration => [ax, ay, az]}
    acceleration = ax.abs + ay.abs + az.abs
    min_acceleration, result1 = acceleration, particles.count-1 if acceleration < min_acceleration || particles.count == 1
end
particles.each_index {|i| (i+1..particles.count-1).each {|j| distances["#{i},#{j}"] = 0}}
compute_distances(particles, distances)
begin
    old_distances = distances.clone
    collisions = {}
    particles.each_index do |pi|
        next unless particles[pi]
        (0..2).each do |i|
            particles[pi][:velocity][i] += particles[pi][:acceleration][i]
            particles[pi][:position][i] += particles[pi][:velocity][i]
        end
        key = particles[pi][:position].join(",")
        collisions[key] = [] unless collisions.has_key?(key)
        collisions[key] << pi
    end
    collisions.each_value {|c| c.each {|pi| particles[pi] = nil} if c.count > 1}
    compute_distances(particles, distances)
    distances.each_key {|key| distances.delete(key) if distances[key] > old_distances[key]}
end while distances.count > 0
result2 = particles.compact.count

puts "Part 1: #{result1}"
puts "Part 2: #{result2}"
