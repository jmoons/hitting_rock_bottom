
class HittingRockBottom
	
	def initialize(args)
		@cave_map		 						= parse_input_file(args)
		@total_water_units 			= File.open(args).readline
		@volume_of_each_column 	= initialize_volume

	end

	def pump_water
		(1..@total_water_units.to_i).each do |water_unit|
			water_placed = false
			@cave_map.reverse!.each do |cave_map_row|
				break if water_placed
				cave_map_row.each_with_index do |cave_map_row_item, index|
					break if water_placed
					if cave_map_row_item == " "
						cave_map_row[index] = "~"
						water_placed = true
					end
				end
			end
		end
		@cave_map
	end

	def print_map
		@cave_map.each{|row| puts row.inspect + "\n"}
	end

	private

	def initialize_volume
		volume = []
		(1..@cave_map.first.length).each{|column| volume << 0}
		volume
	end

	def parse_input_file(input_file)
		parsed_input_file = []
		File.open(input_file).each_line do |line|
			next unless line.start_with?("#") || line.start_with?("~")
			parsed_input_file << line.chomp.split(//)
		end
		parsed_input_file
	end
  
	
end

# HittingRockBottom.new("PuzzleNodeFiles/simple_cave.txt").pump_water
test = HittingRockBottom.new("PuzzleNodeFiles/simple_cave.txt")
test.pump_water
test.print_map