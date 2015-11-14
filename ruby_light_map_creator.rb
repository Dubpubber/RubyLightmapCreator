=begin
  #========
  Description
  #========

  'The Ruby LightMap Creator'

    RLMC is a program used to generate a random lightmap of random color variation or told color variation based on argumentation.

  #========
  Example Usage
  #========

  - Command shortcuts
    $ lightmap -> lm
    $ generate -> g
    $ variation -> v
    $ width -> w
    $ height -> h
    $ color -> c

  - Maximums
    $ width -> 1000px
    $ height -> 1000px
    $ variation -> 2..250

  - Generate simple lightmap of random color variation. (default size: 250px * 250px)
    $ lightmap generate

  - Generate simple light map but with color variation limits
    - Explanation: We're giving RLMC 10 colors of similar hue to work with. (lighter and darker hues)
    $ lightmap generate v 10

  - Generate simple light map with color variation limits, fixed size and starter color (hex value).
    $ lightmap generate v 10 w 250 h 500 c FFFFFF

=end

require 'paleta'
require 'binary_search/pure'

module Constants
  MIN_V = 2
  MAX_V = 250

  MIN_W = 250
  MAX_W = 1000

  MIN_H = 250
  MAX_H = 1000

  # 5 * 5 pixels
  MAX_SIZE = 5

  DEFAULT_COLOR = '000099'

  COMMANDS_ALIAS = {
      :lightmap_command => %w(lm lightmap)
  }
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end

class RubyLightMapCreator

  # Gets a command from the console.
  def get_command
    puts 'Please enter your command.'
    command = gets.chomp
    puts 'Processing...'
    parse_command(command)
  end

  # Parses the input from the console.
  def parse_command(input)
    command_array = input.split(' ')
    if Constants::COMMANDS_ALIAS[:lightmap_command].include? command_array[0].to_s.downcase
      # Lightmap command verified. Can proceed. Now get the action command.
      action_command = command_array[1].to_s.downcase
      case action_command
        when 'generate', 'g'
          # We're generating a lightmap. Pass the rest of the command array to the generation function.
          # Remove the first two elements so param processing is easier and faster.
          command_array -= %W(#{command_array[0].to_s.downcase} #{action_command})
          am_generate(command_array)
        else
          puts 'Couldn\'t parse action command.'
      end
    else
      puts 'Found nothing. Refer to source for explanation and usage.'
    end
  end

  # Where the true magic happens.
  def am_generate(command_array)
    # So, order doesn't matter for parameters. It can come in any order.
    # We're going to program that same way using a switch statement.
    # With a switch statement, it doesn't matter either way as data is processed in case
    lightmap_formula = [Constants::MIN_V, Constants::MIN_W, Constants::MIN_H, Constants::DEFAULT_COLOR]
    command_array.each_with_index { |param, index|
      case param.to_s.downcase
        # Do we have a variation param? If so, check if applicable and set.
        when 'variation', 'v'
          if command_array[index + 1].nil?
            # Variation parameter was received but the respected index was nil.
            puts 'Variation parameter number was nil.'
          else
            if command_array[index + 1].is_number?
              variation = command_array[index + 1].to_i
              if variation >= Constants::MIN_V && variation <= Constants::MAX_V
                # If criteria is met, set the variable to the lightmap formula.
                lightmap_formula[0] = variation
                puts 'Found a compatible variation parameter!'
              end
            end
          end
        when 'width', 'w'
          if command_array[index + 1].nil?
            # Variation parameter was received but the respected index was nil.
            puts 'Width parameter number was nil.'
          else
            if command_array[index + 1].is_number?
              width = command_array[index + 1].to_i
              if width >= Constants::MIN_W && width <= Constants::MAX_W
                # If criteria is met, set the variable to the lightmap formula.
                lightmap_formula[1] = width
                puts 'Found a compatible width parameter!'
              end
            end
          end
        when 'height', 'h'
          if command_array[index + 1].nil?
            # Variation parameter was received but the respected index was nil.
            puts 'Height parameter number was nil.'
          else
            if command_array[index + 1].is_number?
              height = command_array[index + 1].to_i
              if height >= Constants::MIN_H && height <= Constants::MAX_H
                # If criteria is met, set the variable to the lightmap formula.
                lightmap_formula[2] = height
                puts 'Found a compatible height parameter!'
              end
            end
          end
        when 'color', 'c'
          color = command_array[index + 1]
          lightmap_formula[3] = color
        else
          # Probably an incremental param ; )
      end
    }
    # Debug print out of the lightmap formula.
    lightmap_formula.each { |part|
      puts "#{part}"
    }
    # --- #
    # Create the color chart from the lightmap formula
    create_color_chart(lightmap_formula)
  end

  #Now, generate a color variation chart from the provided starting color.
  def create_color_chart(lightmap_formula)

    # Thanks jordanstephens! https://github.com/jordanstephens/paleta
    # Makes my life SO much easier.
    color = Paleta::Color.new(:hex, lightmap_formula[3])
    palette = Paleta::Palette.generate(:type => :shades, :from => :color, :size => lightmap_formula[0], :color => color)

    color_chart = []
    max_x = lightmap_formula[1] / 5
    max_y = lightmap_formula[2] / 5
    color_chart[0] = [max_x, max_y, lightmap_formula[0], lightmap_formula[1], lightmap_formula[2], lightmap_formula[3]]
    speckle_sort(lightmap_formula, max_x, max_y, color_chart, palette)

  end

  def populate_chart_with_color(max_x, max_y, color_chart, color)
    for y in 1..max_y
      row = Array.new(max_x)
      for x in 0..max_x
        row[x] = color
      end
      color_chart[y] = row
    end
  end

  # Picks a color from the parameter based on weight
  def pick(weight_array)
    sum = 0
    weight_array.each { |param|
      sum += param[0]
    }

    ran = Random.new.rand(0..sum)
    weight_array.binary_search { |v| ran <=> v[0] }
  end

=begin
  Speckle sort is an algorithm that attempts to "sort" the color chart by randomness weight.
  Step by Step:
   - First, SS populates the entire color_chart with the dominate color.
   - Then, SS asks for the weight of each palette color.
   - After, using the newly acquired weights, SS will generate a lightmap from the given code.
=end
  def speckle_sort(lightmap_formula, max_x, max_y, color_chart, palette)
    populate_chart_with_color(max_x, max_y, color_chart, lightmap_formula[3])

    @weight_classes = []
    palette.each_with_index { |param, index|
      input = nil
      until input.is_a?(Fixnum) do
        print "Please enter a random weight for color #{param.hex}: "
        begin
          input = Integer(gets)
          @weight_classes[index] = [input, param.hex]
          puts "Added weight (#{input}) for #{param.hex} successfully!"
        rescue ArgumentError
          puts 'That wasn\'t a number. Please enter a number.'
          input = nil
        end
      end
    }

    puts "Done. Finalized size: #{@weight_classes.length}"
    @weight_classes.sort

    for y in 1..max_y
      row = Array.new(max_x)
      for x in 0..max_x

      end
      color_chart[y] = row
    end

    100.times do
      out = pick(@weight_classes)
      puts "Iteration: #{out}"
    end

  end

  def print_color_chart(color_chart)
    color_chart.each { |row|
      p row
    }
  end

  def write_to_file(color_chart)
    File.open('out.txt', 'w') { |file|
      color_chart.each { |row|
        file.write(row)
      }
    }
  end



end

RubyLightMapCreator.new.get_command