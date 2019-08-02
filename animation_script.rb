require 'require_all'

require_all "ascii_animation"

def animation
  2.times do
    i = 1
    while i < 58
      print "\033[2J"
      File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
      sleep(0.04)
      i += 1
    end
  end
  i = 1
  while i < 16
    print "\033[2J"
    File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
    sleep(0.04)
    i += 1
  end
end
