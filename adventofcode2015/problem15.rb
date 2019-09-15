input = ""
File.open("input15.txt", 'r') {|f| input = f.read}

ingredients = []
input.split(/\n/).each do |line|
	capacity, durability, flavor, texture, calories = line.match(/\w+: capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)/).captures
	ingredients << {"capacity" => capacity.to_i, "durability" => durability.to_i, "flavor" => flavor.to_i, "texture" => texture.to_i, "calories" => calories.to_i, "quantity" => 0}
end
def score(ingredients, calorielimit)
	total = {"capacity" => 0, "durability" => 0, "flavor" => 0, "texture" => 0, "calories" => 0}
	ingredients.each do |ingredient|
		total["capacity"] += ingredient["capacity"] * ingredient["quantity"]
		total["durability"] += ingredient["durability"] * ingredient["quantity"]
		total["flavor"] += ingredient["flavor"] * ingredient["quantity"]
		total["texture"] += ingredient["texture"] * ingredient["quantity"]
		total["calories"] += ingredient["calories"] * ingredient["quantity"]
	end
	total.each_key {|key| total[key] = 0 if total[key] < 0}
	return 0 if calorielimit && total["calories"] != calorielimit
	return total["capacity"] * total["durability"] * total["flavor"] * total["texture"]
end
def add_ingredient(ingredients, calorielimit = nil, i = 0, remaining = 100, bestscore = 0)
	if i == ingredients.count - 1
		quantity = 0
		ingredients.each {|j| quantity += j["quantity"]}
		ingredients[i]["quantity"] += 100 - quantity
		currentscore = score(ingredients, calorielimit)
		bestscore = currentscore if currentscore > bestscore
	else
		for j in 0..remaining
			ingredients[i]["quantity"] = j
			bestscore = add_ingredient(ingredients, calorielimit, i + 1, remaining - j, bestscore)
		end
	end
	return bestscore
end

puts "Part 1: #{add_ingredient(ingredients)}"
puts "Part 2: #{add_ingredient(ingredients, 500)}"
