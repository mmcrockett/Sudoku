namespace :admin  do
  desc "Load sudoku boards"
  task :boards => :environment do
    print "What size board?"
    size = $stdin.gets.to_i
    Board.generate(size)
    settings = Settings.new()
    settings.size = size
    Board.where(:size => size).pluck(:id).shuffle!.each do |board_id|
      randomizer = Randomizer.new()
      randomizer.board_id = board_id
      randomizer.save()

      if (nil == settings.min_randomizer_id)
        settings.min_randomizer_id = randomizer.id
      else
        settings.max_randomizer_id = randomizer.id
      end
    end
    settings.save()
  end
end
