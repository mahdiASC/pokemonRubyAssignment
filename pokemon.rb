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
		# Type chart
		# https://i.stack.imgur.com/RBHCa.png
		if @attack.type == "grass"
			if pokemon.type == "fire"
				0.8
			elsif pokemon.type == "grass"
				0.8
			elsif pokemon.type == "water"
				1.25
			end
		elsif @attack.type == "fire"
			if pokemon.type == "grass"
				1.25
			elsif pokemon.type == "water"
				0.8
			elsif pokemon.type == "fire"
				0.8
			end
		elsif @attack.type == "water"
			if pokemon.type == "grass"
				0.8
			elsif pokemon.type == "water"
				0.8
			elsif pokemon.type == "fire"
				1.25
			end
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
		totalDamage = (0.5 * (power) * (atk/defense) * (stab) * (effective)).floor + 1 

		pokemon.hp = pokemon.hp - totalDamage
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

class Player
	attr_accessor :roster, :currentPokemon

	def initialize
		@roster = randRoster
		@currentPokemon = @roster[0]
	end

	def changePokemon(index)
		@currentPokemon = @roster[index]
	end

	def currentPokeAlive?
		@currentPokemon.hp > 0
	end

	def anyAlive?
		counter = 0
		index = 0
		@roster.length.times do
			if @roster[index].hp > 0
				counter = counter + 1
			end
		end
		counter > 0
	end
end

class CompPlayer < Player
	# class inheritence from Player class
	# want to have computer automatically make choice

	def nextPokemon
		index = 0
		while !currentPokeAlive? do
			index = index + 1
			changePokemon(index)
		end
	end
end

# Variables exist only within the scope of the environment they're in

def randPokemon
	#Focus on 2 pokemon for now from
	# https://pokemongo.gamepress.gg/pokemon-list
	name = ["Bulbasaur","Charmander","Squirtle"]
	#not worrying about double effectiveness
	types = ["grass","fire","water"]
	baseAtk = [118,116,94]
	baseDef = [118,96,122]
	baseStam = [90,78,88]
	attack = [["Power Whip","grass",70],["Flamethrower","fire",55],["Aqua Tail","water",45]]
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

class Game
	attr_accessor :humanPlayer, :compPlayer

	def initialize
		@humanPlayer = Player.new
		@compPlayer = CompPlayer.new
	end

	def call
		# This contains your games logic and UX (puts)
		Start game with player or computer going randomly

	end
end