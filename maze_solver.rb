class MazeSolver
  attr_reader :maze, :traveled_path, :visited_nodes, :node_queue
  def initialize(maze)
    @maze = maze # ASCII Maze Input to Class Var
    @maze_array=[] # @maze variable parsed into an array of rows
    @start=[] # coordinates of start of maze indicated by "→"
    @end=[] # coordinates of end of maze indicated by "@"
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @nodes=[]
    @levels=[]
  end

  def maze_array
    @maze_array = @maze.split("\n").map do |maze_row|
      maze_row.strip.split(//)
    end
  end

  def startend
    @maze_array.each do |maze_row|
      if maze_row.index("→")
        @start = [maze_row.index("→"), @maze_array.index(maze_row)]
        @visited_nodes << @start
        @node_queue << @start
        @levels[0] = [@start]
      elsif maze_row.index("@")
        @end = [maze_row.index("@"), @maze_array.index(maze_row)]
        @nodes << @end
      end
    end
  end

  def possible_nodes
    y = 0
    x = 0
    while y < @maze_array.length
      while x <@maze_array[y].length
        @nodes << [x, y] if @maze_array[y][x] == " "
        x += 1
      end
      y += 1
      x = 0
    end
  end

  def breadth
    counter = 1
    until @node_queue.include?(@end)
      new_node_queue = []
      @node_queue.each do |current_node|
        x, y = current_node
        if @nodes.include?([x+1, y]) &&
          !@visited_nodes.include?([x+1, y])
          new_node_queue << [x+1, y]
          @visited_nodes << [x+1, y]
        end
        if @nodes.include?([x-1, y]) &&
          !@visited_nodes.include?([x-1, y])
          new_node_queue << [x-1, y]
          @visited_nodes << [x-1, y]
        end
        if @nodes.include?([x, y+1]) &&
          !@visited_nodes.include?([x, y+1])
          new_node_queue << [x, y+1]
          @visited_nodes << [x, y+1]
        end
        if @nodes.include?([x, y-1]) &&
          !@visited_nodes.include?([x, y-1])
          new_node_queue << [x, y-1]
          @visited_nodes << [x, y-1]
        end
      end
      @levels[counter]=new_node_queue
      @node_queue = new_node_queue
      counter += 1
    end
  end

  def solve
    maze_array
    startend
    possible_nodes
    breadth
    @traveled_path << @start << @end
    counter = 1
    while counter <= @levels.length-2
      if @levels[counter].length == 1
        @traveled_path << @levels[counter][0]
        counter+=1
      else
        @levels[counter].map do |coord|
          x, y = coord
          if (@levels[counter+1].include?([x+1, y]) ||
              @levels[counter+1].include?([x-1, y]) ||
              @levels[counter+1].include?([x, y+1]) ||
              @levels[counter+1].include?([x, y-1])) &&
             (@levels[counter-1].include?([x+1, y]) ||
              @levels[counter-1].include?([x-1, y]) ||
              @levels[counter-1].include?([x, y+1]) ||
              @levels[counter-1].include?([x, y-1]))
              @traveled_path << coord
              counter+=1
          else
            @levels[counter].delete(coord)
          end
        end
      end
    end
    solution_path
  end

  def solution_path
    @traveled_path
  end

  def display_solution_path
    solve
    solved_array = @maze_array
    @traveled_path.each do |coord|
      x, y = coord
      solved_array[y][x] = "." if solved_array[y][x] == " "
    end
    solved_array = solved_array.map do |row|
      row.join
    end.join("\n")
    puts solved_array
  end
end

maze =
"
      ######################
      #         #          #
      # ## ### ######## ## #
      →   #     #   #      #
      ### # ### ## ### ##  #
      #     #   #          #
      # ##########    ######
      # #   #              @
      # ### ########## #####
      #         #          #
      ######################"

ms = MazeSolver.new(maze)
ms.display_solution_path
