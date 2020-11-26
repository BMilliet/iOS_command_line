module CLI
  module UI
    def self.log(message, color)
      color_code = 32
      case color
      when 'red';          color_code = 31
      when 'blue';         color_code = 34
      when 'pink';         color_code = 35
      when 'light_blue';   color_code = 36
      else;                color_code = 32
      end
      puts "\e[#{color_code}m#{message}\e[0m"
    end

    def self.select_option(options)
      options.each_with_index { |e, i| puts "#{i} => #{e}" }
      puts "\nchoose option number:"
      choosen = gets.chomp.to_i
      abort "out of range" if choosen > options.length or choosen < 0
      options[choosen]
    end
  end
end
