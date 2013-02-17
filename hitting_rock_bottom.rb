
class HittingRockBottom

  WATER_INDICATOR = "~"
  ROCK_INDICATOR  = "#"
  AIR_INDICATOR   = " "

  def initialize(args)
    @cave_map               = parse_input_file(args)
    @total_water_units      = File.open(args).readline
    @volume_of_each_column  = initialize_volume
    @current_water_position = find_initial_water_position

  end

  def pump_water
    (1..@total_water_units.to_i).each do |water_unit|
      place_water
    end
  end

  def print_map
    @cave_map.each{|row| puts row.inspect + "\n"}
  end

  private

  def place_water
    if flow_down?
      puts "FLOW DOWN"
    elsif flow_right?
      puts "FLOW RIGHT"
    elsif flow_up?
    else
      #TOP RIGHT
    end
    # HAVE METHODS TO GET POSITION DOWN, RIGHT, or ABOVE
  end

  def flow_down?
    return false if @current_water_position[:row] == @cave_map.length - 1 # NOTE: This assumes a gap in the # floor is possible
    candidate_position = {:row => @current_water_position[:row] + 1, :position => @current_water_position[:position]}
    if @cave_map[candidate_position[:row]][candidate_position[:position]] == AIR_INDICATOR
      #mark the cave map
      place_water_indicator(candidate_position)

      #update current position
      update_current_water_position(candidate_position)

      #increment volume (we have :position here, so a array of values associated to each column should be simple)
      #TODO
      return true
    else
      return false
    end
  end

  def flow_right?
    return false if @current_water_position[:position] == @cave_map.first.length - 1 # Far right
    candidate_position = {:row => @current_water_position[:row], :position => @current_water_position[:position] + 1}
    if @cave_map[candidate_position[:row]][candidate_position[:position]] == AIR_INDICATOR
      #mark the cave map
      place_water_indicator(candidate_position)

      #update current position
      update_current_water_position(candidate_position)

      #increment volume
      #TODO
      return true
    else
      return false
    end
  end

  def flow_up?
    true
  end

  def place_water_indicator(position)
    @cave_map[position[:row]][position[:position]] = WATER_INDICATOR
  end

  def update_current_water_position(position)
    @current_water_position[:row]       = position[:row]
    @current_water_position[:position]  = position[:position]
  end

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