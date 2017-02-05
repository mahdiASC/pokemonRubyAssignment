class Pokemon
	attr_accessor :name,:type,:hp,:baseAtk, :baseDef, :baseStam, :atkIV, :defIV, :stamIV, :attack

	def initialize(name,type,baseAtk, baseDef, baseStam, attack)
		@name = name
		@type = type
		@baseAtk = baseAtk
		@baseDef = baseDef
		@baseStam = baseStam
		@atkIV = rand(16)
		@defIV = rand(16)
		@stamIV = rand(16)
		@attack = attack
		@hp = ((baseStam+stamIV)*0.79).floor
	end


	def calcEffectiveness(pokemon)
		if @type == "grass"
			if pokemon.type == ""
		elsif @type == "fire"

		elsif @type == "water"

		else
			puts "Something's not right!"
		end
	end

	def attacks(pokemon)
		power = @attack.damage
		atk = (@baseAtk + @atkIV) * 0.79
		defense = (pokemon.baseDef+pokemon.defIV) * 0.79

		if @type == @attack.type
			stab = 1.25
		else
			stab = 1
		end
		# stab = @type == @attack.type ? 1.25 : 1

		effective = calcEffectiveness(pokemon)
		#DO THIS FIRST
		# https://pokemongo.gamepress.gg/damage-mechanics
		(0.5 * (power) * (atk/defense) * (stab) * (effective)).floor + 1 
	end

end

class Attack
	attr_accessor :name, :type, :damage

	def initialize(name, type, damage)
		@name = name
		@type = type
		@damage = damage
	end
end

# Variables exist only within the scope of the environment they're in

def randPokemon
	#Focus on 2 pokemon for now from
	# https://pokemongo.gamepress.gg/pokemon-list
	name = ["Bulbasaur","Charmander","Squirtle"]
	#not worrying about double effectiveness
	types = ["Grass","Fire","Water"]
	baseAtk = [118,116,94]
	baseDef = [118,96,122]
	baseStam = [90,78,88]
	attack = [["Power Whip","Grass",70],["Flamethrower","Fire",55],["Aqua Tail","Water",45]]
	pick = rand(name.length)

	Pokemon.new(name[pick],types[pick],baseAtk[pick],baseDef[pick],baseStam[pick], Attack.new(attack[pick][0],attack[pick][1],attack[pick][2]))
end

def randRoster(num = 6)
	output = []
	num.times do
		output.push(randPokemon)
	end
	output
end

