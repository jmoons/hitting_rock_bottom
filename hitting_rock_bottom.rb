
class HittingRockBottom
	
	def initialize(args)
		@input_file = parse_input_file(args)
		@total_water_units = File.open(args).readline
		
	end

	def parse_input_file(input_file)
		parsed_input_file = []
		File.open(input_file).each_line do |line|
			next unless line.start_with?("#") || line.start_with?("~")
			parsed_input_file << {:depth => 0, :map => line.chomp.split(//)}
		end
		parsed_input_file
	end
  
	
end

HittingRockBottom.new("PuzzleNodeFiles/simple_cave.txt")