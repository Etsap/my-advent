input = ""
File.open("input21.txt", 'r') {|f| input = f.read}

boss_stats = {}
input.split(/\n/).each do |line|
	stat, value = line.split(/: /)
	boss_stats[stat] = value.to_i
end
equipment = {"Dagger" => {"Cost" => 8, "Damage" => 4, "Armor" => 0}, "Shortsword" => {"Cost" => 10, "Damage" => 5, "Armor" => 0}, "Warhammer" => {"Cost" => 25, "Damage" => 6, "Armor" => 0}, "Longsword" => {"Cost" => 40, "Damage" => 7, "Armor" => 0}, "Greataxe" => {"Cost" => 74, "Damage" => 8, "Armor" => 0}, "None" => {"Cost" => 0, "Damage" => 0, "Armor" => 0}, "Leather" => {"Cost" => 13, "Damage" => 0, "Armor" => 1}, "Chainmail" => {"Cost" => 31, "Damage" => 0, "Armor" => 2}, "Splintmail" => {"Cost" => 53, "Damage" => 0, "Armor" => 3}, "Bandedmail" => {"Cost" => 75, "Damage" => 0, "Armor" => 4}, "Platemail" => {"Cost" => 102, "Damage" => 0, "Armor" => 5}, "Damage +1" => {"Cost" => 25, "Damage" => 1, "Armor" => 0}, "Damage +2" => {"Cost" => 50, "Damage" => 2, "Armor" => 0}, "Damage +3" => {"Cost" => 100, "Damage" => 3, "Armor" => 0}, "Defense +1" => {"Cost" => 20, "Damage" => 0, "Armor" => 1}, "Defense +2" => {"Cost" => 40, "Damage" => 0, "Armor" => 2}, "Defense +3" => {"Cost" => 80, "Damage" => 0, "Armor" => 3}}
combinations = []
rings = ["None", "Damage +1", "Damage +2", "Damage +3", "Defense +1", "Defense +2", "Defense +3"]
["Dagger", "Shortsword", "Warhammer", "Longsword", "Greataxe"].each do |w|
	["None", "Leather", "Chainmail", "Splintmail", "Bandedmail", "Platemail"].each do |a|
		(0..6).each do |r1|
			(r1..6).each do |r2|
				combinations << [w, a, rings[r1], rings[r2]] if r1 != r2 || r1 == 0
			end
		end
	end
end
def total_cost(equipment, mystuff)
	total = 0
	mystuff.each {|e| total += equipment[e]["Cost"]}
	return total
end
def find_combination(combinations, equipment, boss_stats, win)
	combinations.each do |c|
		player_stats = {"Hit Points" => 100, "Damage" => 0, "Armor" => 0}
		c.each do |e|
			player_stats["Armor"] += equipment[e]["Armor"]
			player_stats["Damage"] += equipment[e]["Damage"]
		end
		damage1 = player_stats["Damage"] - boss_stats["Armor"]
		damage1 = 1 if damage1 < 1
		damage2 = boss_stats["Damage"] - player_stats["Armor"]
		damage2 = 1 if damage2 < 1
		return total_cost(equipment, c) if win == (boss_stats["Hit Points"] / damage1 <= player_stats["Hit Points"] / damage2)
	end
end

puts "Part 1: #{find_combination(combinations.sort_by{|a| total_cost(equipment, a)}, equipment, boss_stats, true)}"
puts "Part 2: #{find_combination(combinations.sort_by{|a| -total_cost(equipment, a)}, equipment, boss_stats, false)}"
