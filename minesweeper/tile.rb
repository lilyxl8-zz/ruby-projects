class Tile

  attr_reader :status, :pos, :board, :neighbors, :is_bomb, :neighbor_bomb_count


  NEIGHBOR_DELTAS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]]

  def initialize(board, pos, is_bomb = false)
    @pos = pos
    @status = :covered
    @is_bomb = is_bomb
    @board = board
    @neighbors = []
    @neighbor_bomb_count = 0
  end

  def reveal
    @status = :revealed
    depth_first_reveal if neighbor_bomb_count == 0
    is_bomb
  end

  def depth_first_reveal
    neighbors.each do |neighbor|
      unless neighbor.status == :revealed || neighbor.is_bomb
        neighbor.reveal
      end
    end
  end

  def flag
    @status = :flagged

    nil
  end

  def render(debug_mode = false)
    return reveal_render if debug_mode

    case status
    when :covered
      "*"
    when :revealed
      reveal_render
    when :flagged
      "F"
    end
  end

  def reveal_render
    return "X" if is_bomb
    return "_" if neighbor_bomb_count == 0
    neighbor_bomb_count.to_s
  end

  def populate_neighbors
    return nil unless neighbors.empty?
    NEIGHBOR_DELTAS.each do |delta|
      new_pos = [pos[0] + delta[0], pos[1] + delta[1]]

      neighbors << board[new_pos] if board.on_board?(new_pos)
    end

    set_neighbor_bomb_count
    nil
  end

  def set_neighbor_bomb_count
    neighbors.each do |neighbor|
      @neighbor_bomb_count += 1 if neighbor.is_bomb
    end

    nil
  end

  def inspect
    pos
  end

end
