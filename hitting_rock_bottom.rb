class HittingRockBottom

  WATER_INDICATOR = "~"
  ROCK_INDICATOR  = "#"
  AIR_INDICATOR   = " "

  def initialize(args)
    @cave_map               = parse_input_file(args)
    @total_water_units      = File.open(args).readline.to_i
    @volume_of_each_column  = initialize_volume
    @current_water_position = find_initial_water_position
  end

  def pump_water
    (1..@total_water_units).each do |water_unit|
      place_water(water_unit)
    end
  end

  def print_map
    puts @volume_of_each_column.inspect
    @cave_map.each{|row| puts row.inspect + "\n"}
  end

  def print_output
    output = ""
    @volume_of_each_column.each do |volume_unit|
      if volume_unit.is_a?(Integer)
        output << "#{volume_unit} "
      else
        output << "~ "
      end
    end
    puts output
  end

  private

  def place_water(water_unit)
    if flow_down?(water_unit)
      puts "FLOW DOWN"
    elsif flow_right?(water_unit)
      puts "FLOW RIGHT"
    elsif flow_up?(water_unit)
      puts "FLOW UP"
    else
      puts "NO MOVE"
      #TOP RIGHT
    end
  end

  def flow_down?(water_unit)
    return false if @current_water_position[:row] == @cave_map.length - 1 # NOTE: This assumes a gap in the # floor is possible
    candidate_position = {:row => @current_water_position[:row] + 1, :column => @current_water_position[:column]}
    if @cave_map[candidate_position[:row]][candidate_position[:column]] == AIR_INDICATOR
      #mark the cave map
      place_water_indicator(candidate_position)

      #update current position
      update_current_water_position(candidate_position)

      #increment volume (we have :column here, so a array of values associated to each column should be simple)
      increment_column_volume(candidate_position[:column], water_unit)
      return true
    else
      return false
    end
  end

  def flow_right?(water_unit)
    return false if @current_water_position[:column] == @cave_map.first.length - 1 # Far right
    candidate_position = {:row => @current_water_position[:row], :column => @current_water_position[:column] + 1}
    if @cave_map[candidate_position[:row]][candidate_position[:column]] == AIR_INDICATOR
      #mark the cave map
      place_water_indicator(candidate_position)

      #update current position
      update_current_water_position(candidate_position)

      #increment volume
      increment_column_volume(candidate_position[:column], water_unit)
      return true
    else
      return false
    end
  end

  def flow_up?(water_unit)
    #go up one, row, scan for last '~' and see if you can put one to the right, if not, go up again
    
    #make sure we are not at the top of the cave
    return false if @current_water_position[:row] == 0 #NOTE: This assumes a gap in the ceiling is possible
    row_offset = 1
    working = true
    success = false

    candidate_row_index = @current_water_position[:row] - row_offset
    candidate_position  = { :row => candidate_row_index,
                            :column => find_last_water_in_row(candidate_row_index) }
    while working do
      if @cave_map[candidate_position[:row]][candidate_position[:column]] == AIR_INDICATOR
        #mark the cave map
        place_water_indicator(candidate_position)

        #update current position
        update_current_water_position(candidate_position)

        #increment volume
        increment_column_volume(candidate_position[:column], water_unit)

        #break from while
        success = true
        working = false
      else
        #try next row up if possible
        row_offset += 1
        if @current_water_position[:row] - row_offset == 0
          success = false
          working = false
        else
          candidate_row_index = @current_water_position[:row] - row_offset
          candidate_position  = { :row => candidate_row_index,
                                  :column => find_last_water_in_row(candidate_row_index) }
        end
      end
    end
    return success
  end

  def find_last_water_in_row(row_index)
    @cave_map[row_index].rindex(WATER_INDICATOR) + 1
  end

  def place_water_indicator(position)
    @cave_map[position[:row]][position[:column]] = WATER_INDICATOR
  end

  def update_current_water_position(position)
    @current_water_position[:row]     = position[:row]
    @current_water_position[:column]  = position[:column]
  end

  def increment_column_volume(column, water_unit)
    @volume_of_each_column[column] += 1
    if (water_unit == @total_water_units)
      #Check to see if we are mid-flow, if yes, turn that value to a string
      if (@cave_map[@current_water_position[:row] + 1][@current_water_position[:column]]) == AIR_INDICATOR
        @volume_of_each_column[column] = @volume_of_each_column[column].to_s
      end
    end
  end

  def find_initial_water_position
    water_position = {}
    found_it = false
    @cave_map.each_with_index do |map_row, row_index|
      break if found_it
      map_row.each_with_index do |map_row_item, item_index|
        if map_row_item == WATER_INDICATOR
          water_position = {:row => row_index, :column => item_index}
          found_it = true
          break
        end
      end
    end
    water_position
  end

  def initialize_volume
    volume = [1] #This assumes we always start with one initial volume of water
    (1...@cave_map.first.length).each{|column| volume << 0}
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

test = HittingRockBottom.new("PuzzleNodeFiles/complex_cave.txt")
test.pump_water
# test.print_map
test.print_output