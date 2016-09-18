
MAZE1 = %{#####################################
# #   #           #                 #
# ### # ####### # # # ############# #
#   #   #     # #   # #     #     # #
### ##### ### ####### # ##### ### # #
# #       # #  A  #   #       #   # #
# ######### ##### # ####### ### ### #
#               ###       # # # #   #
# ### ### ####### ####### # # # # ###
# # # #   #     #B#   #   # # #   # #
# # # ##### ### # # # # ### # ##### #
#   #         #     #   #           #
#####################################}

puts MAZE1
#MAZE2=MAZE1.chars.to_a
# maze_matrix=MAZE1.split("\n").map { |row| row.split('') }
# maze_matrix.each_with_index do |x, xi|
#   x.each_with_index do |y, yi|
#     puts "element [#{xi}, #{yi}] is #{y}"
#   end
# end

class MazeSolver
	MOVEMENTS=[[1,0],[0,1],[-1,0],[0,-1]]
	SPACE_CHAR=' '
	VISITED_TRACK='$'
	def initialize(maze)
		@maze_matrix=maze.split("\n").map { |row| row.split('') }
		@maze_matrix.each_with_index do |x, xi|
  			x.each_with_index do |y, yi|
    		if y == "A"
    			#puts "Start found at #{xi} #{yi}"
    			@start_row=xi
    			@start_column=yi
    			#puts "just printing #{maze[0][0]}"
  			end
		end
		end
	end
	
	def getMaze
		@maze_matrix
	end
	def checkDestination?
		MOVEMENTS.each do |delta| 
			#puts @maze_matrix[@start_row+delta[0]][@start_column+delta[1]]
			return true if @maze_matrix[@start_row+delta[0]][@start_column+delta[1]]=="B"
			end
			false
	end
	def moveaStep(delta)
		@maze_matrix[@start_row + delta[0]][@start_column + delta[1]]=VISITED_TRACK
		@start_row+=delta[0]
		@start_column+=delta[1]
	end
	def checkMovement?(delta)
		delta[0] != delta[1] and @maze_matrix[@start_row + delta[0]][@start_column + delta[1]] == SPACE_CHAR
	end
	def  availableMoves
		deltas = []
		MOVEMENTS.each do |delta| 
			deltas.push(delta) if checkMovement?(delta)
		end
		deltas
	end
	def backaStep(delta)
  		reverse =delta.map {|x| -x}
  		@maze_matrix[@start_row][@start_column]=SPACE_CHAR
  		@start_row+=reverse[0]
  		@start_column+=reverse[1]
  	end
	def solvable?
		availableMoves.each do |delta|
			moveaStep delta 
			break if solvable?
			backaStep delta
		end
		checkDestination?
	end
	def to_s
    @maze_matrix.map { |row| row.join('') }.join("\n")
  	end
  	


end

	solver=MazeSolver.new(MAZE1)
	puts "the maze is solvable #{solver.solvable?}"
	puts solver