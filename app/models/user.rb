class User < ActiveRecord::Base
  attr_accessible :preferences

  serialize :preferences, JSON

  before_create :defaults

  def defaults(size = 4)
    if (false == self.preferences.is_a?(Hash))
      self.preferences = {}
    end

    if (false == self.preferences.include?('board'))
      self.preferences['board']  = {}
    end

    if (false == self.preferences.include?('difficulty'))
      self.preferences['difficulty']  = 1
    end

    self.preferences['size']  = size

    if (false == self.preferences['board'].include?(size))
      self.preferences['board'][size] = {}
      self.preferences['board'][size]['order'] = Board.pluck(:id).shuffle!
      self.preferences['board'][size]['index'] = 0
    end
  end

  def size
    x = self.preferences['size']

    if (nil == x)
      raise "!ERROR: user not initialized correctly. Size not set."
    end

    return x
  end

  def index
    x = self.preferences['board']["#{self.size}"]['index']

    if (nil == x)
      raise "!ERROR: user not initialized correctly. Index not set."
    end

    return x
  end

  def boards
    x = self.preferences['board']["#{self.size}"]['order']

    if (nil == x)
      raise "!ERROR: user not initialized correctly. Order not set."
    end

    return x
  end

  def difficulty=(value)
    v = value.to_i

    if ((3 >= v) && (1 <= v))
      self.preferences['difficulty'] = v
    else
      raise "!ERROR: Not a valid difficulty '#{v}' from '#{value}'"
    end
  end

  def difficulty
    x = self.preferences['difficulty']

    if (nil == x)
      raise "!ERROR: user not initialized correctly. Difficulty not set."
    end

    return x
  end

  def next
    i = self.index
    b = self.boards[i]

    i = ((i + 1) % self.boards.size)
    self.preferences['board']["#{self.size}"]['index'] = i
    self.save

    return b
  end
end
