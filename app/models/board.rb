require 'set'

class Board < ActiveRecord::Base
  attr_accessible :data, :size

  serialize :data, JSON

  def self.generate(size)
    boards = []
    all_lines = nil
    quadsize  = Math.sqrt(size).to_i

    if (quadsize**2 != size)
      raise "Not a valid board size. Quadsize: #{quadsize**2}. Board size: #{size}"
    end

    all_lines = (1..size).to_a.permutation.to_a
    all_lines_indices = (0..(all_lines.size-1)).to_a.permutation(size).to_a

    all_lines_indices.each do |line_index|
      board = Board.new({:size => size, :data => []})

      line_index.each do |i|
        board.data << all_lines[i]
      end

      if (true == board.prevalid?)
        board.save
        boards << board
      end
    end

    return boards
  end

  def valid_set?(set)
    if (true == set.is_a?(Array))
      set = set.to_set
    end

    return (set == (1..self.size).to_set)
  end

  def prevalid?
    if (false == self.size.is_a?(Integer))
      raise "!ERROR: Board size must be an integer: '#{self.size}'."
    end

    quadsize = Math.sqrt(self.size).to_i

    if (quadsize**2 != self.size)
      raise "!ERROR: Not a valid board size. Quadsize: '#{quadsize**2}'. Board size: '#{self.size}'"
    end

    if (self.size != self.data.size)
      raise "!ERROR: Board is not correct size. Board size expected: '#{self.size}' Board: '#{self.data}'."
    else
      self.size.times do |i|
        if (false == self.data[i].is_a?(Array))
          raise "!ERROR: Board row is not array. Board row '#{i}': '#{self.data}'."
        end

        if (self.size != self.data[i].size)
          raise "!ERROR: Board row is not correct size. Board size expected: '#{self.size}' Board row[#{i}]: '#{self.data[i]}'."
        end
      end
    end

    if (true == valid_rows?)
      if (true == valid_columns?)
        return valid_quadrants?(quadsize)
      end
    end

    return false
  end

  def valid_rows?
    self.data.each do |row|
      if (false == valid_set?(row))
        return false
      end
    end

    return true
  end

  def valid_columns?
    self.size.times do |coln|
      column = []
      self.data.each do |row|
        column << row[coln]
      end

      if (false == valid_set?(column))
        return false
      end
    end

    return true
  end

  def valid_quadrants?(qsize)
    self.size.times do |qnum|
      quadrant = []
      x_shift  = qsize * (qnum/qsize)
      y_shift  = qsize * (qnum%qsize)

      qsize.times do |x|
        qsize.times do |y|
          quadrant << self.data[x+x_shift][y]
        end
      end

      if (false == valid_set?(quadrant))
        return false
      end
    end

    return true
  end
end
