class MazeSolver
  attr_reader :maze, :traveled_path, :visited_nodes, :node_queue
  def initialize(maze)
    @maze = maze
    @traveled_path = []
    @visited_nodes = []
    @node_queue = []
    @m_arr=[]
    @start=[]
    @end=[]
    @nodes=[]
    @levels=[]
    maze_array
  end

  def maze_array
    @m_arr = @maze.split("\n").map do |m_row|
      m_row.strip.split(//)
    end
  end

  def startend
    @m_arr.each do |m_row|
      if m_row.index("→")
        @start = [m_row.index("→"), @m_arr.index(m_row)]
        @visited_nodes << @start
        @node_queue << @start
        @levels[0] = [@start]
      elsif m_row.index("@")
        @end = [m_row.index("@"), @m_arr.index(m_row)]
        @nodes << @end
      end
    end
  end

  def possible_nodes
    y = 0
    x = 0
    while y < @m_arr.length
      while x <@m_arr[y].length
        @nodes << [x, y] if @m_arr[y][x] == " "
        x += 1
      end
      y += 1
      x = 0
    end
  end

  def breadth
    startend
    possible_nodes
    ctr = 1
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
      @levels[ctr]=new_node_queue
      @node_queue = new_node_queue
      ctr += 1
    end
    p @levels
  end

  def solve
    breadth
    @traveled_path << @start << @end
    ctr = 1
    while ctr <= @levels.length-2
      if @levels[ctr].length == 1
        @traveled_path << @levels[ctr][0]
        ctr+=1
      else
        @levels[ctr].map do |coord|
          x, y = coord
          if (@levels[ctr+1].include?([x+1, y]) ||
              @levels[ctr+1].include?([x-1, y]) ||
              @levels[ctr+1].include?([x, y+1]) ||
              @levels[ctr+1].include?([x, y-1])) &&
             (@levels[ctr-1].include?([x+1, y]) ||
              @levels[ctr-1].include?([x-1, y]) ||
              @levels[ctr-1].include?([x, y+1]) ||
              @levels[ctr-1].include?([x, y-1]))
              @traveled_path << coord
              ctr+=1
          else
            @levels[ctr].delete(coord)
          end
        end
      end
    end
    @traveled_path
  end

  def solution_path
    @traveled_path
  end

  def display_solution_path
    solve
    s_arr = @m_arr
    @traveled_path.each do |coord|
      x, y = coord
      s_arr[y][x] = "." if s_arr[y][x] == " "
    end
    s_arr = s_arr.map do |row|
      row.join
    end.join("\n")
    puts s_arr
  end
end
