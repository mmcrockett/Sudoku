class User < ActiveRecord::Base
  attr_accessible :difficulty, :size, :indices, :preferences

  serialize :indices, JSON
  serialize :preferences, JSON

  before_create :defaults

  def defaults(size = 4)
    if (false == self.preferences.is_a?(Hash))
      self.preferences = {}
    end

    if (false == self.indices.is_a?(Hash))
      self.indices = {}
    end
  end

  def ssize
    return "#{self.size}"
  end

  def check_index
    if ((false == self.indices.include?(self.ssize)) || (false == self.indices[self.ssize].include?('index')))
      self.indices[self.ssize] ||= {}
      setting = Settings.where(:size => self.size).first
      self.indices[self.ssize]['index'] = setting.min_randomizer_id + rand(setting.max_randomizer_id - setting.min_randomizer_id + 1)
    end
  end

  def index
    self.check_index
    x = self.indices[self.ssize]['index']

    if (nil == x)
      raise "!ERROR: user not initialized correctly. Index not set for #{self.size}."
    end

    return x
  end

  def index=(v)
    self.check_index
    self.indices[self.ssize]['index'] = v
  end

  def increment_index
    setting = Settings.where(:size => self.size).first
    i = self.index
    i += 1
    
    if (i > setting.max_randomizer_id)
      i = setting.min_randomizer_id
    end

    self.index = i
    self.save
  end

  def next
    board_id = Randomizer.find(self.index).board_id
    self.increment_index

    return board_id
  end
end
