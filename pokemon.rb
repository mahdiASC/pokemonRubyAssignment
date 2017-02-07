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
		@hp = ((baseStam+@stamIV)*0.79).floor
	end

	def calcEffectiveness(pokemon)
		# https://i.stack.imgur.com/RBHCa.png
		if @attack.type == "grass"
			if pokemon.type == "fire"
				0.8
			elsif pokemon.type == "grass"
				0.8
			elsif pokemon.type == "water"
				1.25
			else
				1
			end
		elsif @attack.type == "fire"
			if pokemon.type == "grass"
				1.25
			elsif pokemon.type == "water"
				0.8
			elsif pokemon.type == "fire"
				0.8
			else
				1
			end
		elsif @attack.type == "water"
			if pokemon.type == "grass"
				0.8
			elsif pokemon.type == "water"
				0.8
			elsif pokemon.type == "fire"
				1.25
			else
				1
			end
		else
			#for debugging!
			puts "Something's not right!"
		end
	end

	def attacks(pokemon)
		puts @name + " attacks " + pokemon.name + " with " + @attack.name + " for " + calDamage(pokemon).to_s + " damage!"
		pokemon.hp = pokemon.hp - calDamage(pokemon)
	end

	def calDamage(pokemon)
		power = @attack.damage
		atk = (@baseAtk + @atkIV) * 0.79
		defense = (pokemon.baseDef+pokemon.defIV) * 0.79

		if @type == @attack.type
			stab = 1.25
		else
			stab = 1
		end

		effective = calcEffectiveness(pokemon)

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

class Player
	attr_accessor :roster, :currentPokemon

	def initialize
		@roster = randRoster
		@currentPokemon = @roster[0]
	end

	def currentPokeAlive?
		@currentPokemon.hp > 0
	end

	def anyAlive?
		counter = 0
		index = 0
		6.times do
			if @roster[index].hp > 0
				counter = counter + 1
			end
			index = index + 1
		end
		counter > 0
	end

	def changePokemon
		index = 0
		while !currentPokeAlive? do
			@currentPokemon = @roster[index]
			index = index + 1
		end
	end
end

def randPokemon
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

def randRoster
	output = []
	6.times do
		output.push(randPokemon)
	end
	output
end

class Game
	attr_accessor :player1, :player2

	def initialize
		@player1 = Player.new
		@player2 = Player.new
	end

	def call
		# GAME LOGIC
		# Intro for Player
		# Start battle with player1 or player2 going randomly 50/50
		# LOOP! - pokemon go back and forth battling until 1 pokemon has no more hp
		# Next pokemon in line goes for that loser player
		# LOOP! - Repeat until 1 player has no more pokemon in roster with hp
		# end of the game - Determine winner

		#INTRO
		puts "Welcome to my Pokemon game!"

		# LOOPS until one player out of usable pokemon
		while playersHavePokemon? do
			#50/50 who goes
			if rand > 0.5
				#player 1 goes first
				firstAttacker = @player1
				secondAttacker = @player2
			else
				#player 2 goes first
				firstAttacker = @player2
				secondAttacker = @player1
			end #end of 50/50

			while firstAttacker.currentPokeAlive? && secondAttacker.currentPokeAlive? do
				firstAttacker.currentPokemon.attacks(secondAttacker.currentPokemon)
				if secondAttacker.currentPokeAlive?
					secondAttacker.currentPokemon.attacks(firstAttacker.currentPokemon)
				end
			end

			if !@player1.currentPokeAlive? && @player1.anyAlive?
				@player1.changePokemon
			elsif !@player2.currentPokeAlive? && @player2.anyAlive?
				@player2.changePokemon
			end
		end #a player no longer has usable pokemon

		if @player1.anyAlive?
			#player 1 wins!
			winner = "Player 1"
		else
			#player 2 wins!
			winner = "Player 2"
		end
		puts "The winner is " + winner + "!"
	end

	def playersHavePokemon?
		#returns true if any player has usable pokemon
		if @player1.anyAlive? && @player2.anyAlive? 
			true
		else  
			false
		end
	end
end

# Initiating the game
game = Game.new
game.call
