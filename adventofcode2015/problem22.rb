input = ""
File.open("input22.txt", 'r') {|f| input = f.read}

boss_stats = {}
input.split(/\n/).each do |line|
	stat, value = line.split(/: /)
	boss_stats[stat] = value.to_i
end
player_stats = {"Hit Points" => 50, "Mana" => 500}
spells = {"Magic Missile" => {"Cost" => 53, "Duration" => 1, "Damage" => 4}, "Drain" => {"Cost" => 73, "Duration" => 1, "Damage" => 2, "Heal" => 2}, "Shield" => {"Cost" => 113, "Duration" => 6, "Armor" => 7}, "Poison" => {"Cost" => 173, "Damage" => 3, "Duration" => 6}, "Recharge" => {"Cost" => 229, "Mana" => 101, "Duration" => 5}}
def do_effects!(boss_stats, player_stats, effects, mana_spent, lowest_mana)
	player_stats["Armor"] = 0
	effects.each do |name, effect|
		boss_stats["Hit Points"] -= effect["Damage"] if effect.has_key?("Damage")
		player_stats["Hit Points"] += effect["Heal"] if effect.has_key?("Heal")
		player_stats["Armor"] += effect["Armor"] if effect.has_key?("Armor")
		player_stats["Mana"] += effect["Mana"] if effect.has_key?("Mana")
		effect["Duration"] -= 1
	end
	effects.delete_if{|name, duration| duration["Duration"] <= 0}
	return mana_spent, true if mana_spent <= lowest_mana && boss_stats["Hit Points"] <= 0
	return lowest_mana, boss_stats["Hit Points"] <= 0
end
def fight!(boss_stats, player_stats, spells, hard_mode, effects = {}, mana_spent = 0, lowest_mana = 1.0 / 0)
	player_stats["Hit Points"] -= 1 if hard_mode
	lowest_mana, done = do_effects!(boss_stats, player_stats, effects, mana_spent, lowest_mana)
	spells.each_pair do |spell_name, spell|
		if spell["Cost"] <= player_stats["Mana"] && spell["Cost"] + mana_spent < lowest_mana && !effects.has_key?(spell_name)
			this_player_stats, this_boss_stats, this_effects = player_stats.clone, boss_stats.clone, {spell_name => spell.clone}
			effects.each_pair {|name, effect| this_effects[name] = effect.clone}
			this_player_stats["Mana"] -= spell["Cost"]
			lowest_mana, done = do_effects!(this_boss_stats, this_player_stats, this_effects, mana_spent + spell["Cost"], lowest_mana)
			this_player_stats["Hit Points"] -= this_boss_stats["Damage"] > this_player_stats["Armor"] ? this_boss_stats["Damage"] - this_player_stats["Armor"] : 1
			done ||= this_player_stats["Hit Points"] <= (hard_mode ? 1 : 0)
			lowest_mana = fight!(this_boss_stats, this_player_stats, spells, hard_mode, this_effects, mana_spent + spell["Cost"], lowest_mana) unless done
		end
	end
	return lowest_mana
end

puts "Part 1: #{fight!(boss_stats.clone, player_stats.clone, spells, false)}"
puts "Part 2: #{fight!(boss_stats, player_stats, spells, true)}"
