
class HittingRockBottom

  WATER_INDICATOR = "~"
  ROCK_INDICATOR  = "#"
  AIR_INDICATOR   = " "

  def initialize(args)
    @cave_map               = parse_input_file(args)
    @total_water_units      = File.open(args).readline
    @volume_of_each_column  = initialize_volume
    @current_water_position = find_initial_water_position
    puts "DUDE: #{@cave_map[@current_water_position[:row]][@current_water_position[:position]]}"

  end

  def pump_water
    (1..@total_water_units.to_i).each do |water_unit|
    end
  end

  def print_map
    @cave_map.each{|row| puts row.inspect + "\n"}
  end

  private

  def find_initial_water_position
    water_position = {}
    found_it = false
    @cave_map.each_with_index do |map_row, row_index|
      break if found_it
      map_row.each_with_index do |map_row_item, item_index|
        if map_row_item == WATER_INDICATOR
          water_position = {:row => row_index, :position => item_index}
          found_it = true
          break
        end
      end
    end
    water_position
  end

  def initialize_volume
    volume = []
    (1..@cave_map.first.length).each{|column| volume << 0}
    volume
  end

  def parse_input_file(input_file)
    parsed_input_file = []
    File.open(input_file).each_line do |line|
      next unless line.start_with?(ROCK_INDICATOR) || line.start_with?(WATER_INDICATOR)
      parsed_input_file << line.chomp.split(//)
    end
    parsed_input_file
  end
  
  
end

# HittingRockBottom.new("PuzzleNodeFiles/simple_cave.txt").pump_water
test = HittingRockBottom.new("PuzzleNodeFiles/simple_cave.txt")
test.pump_water
test.print_map