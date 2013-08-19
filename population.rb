require_relative "lib/setup"
require_relative "lib/analytics"

class Population
  attr_accessor :analytics

  def initialize
    areas = Setup.new().areas
    @analytics = Analytics.new(areas)
  end

  def menu
    #personally don't like auto-clearing the console, should be a separate choice of its own
    #also eliminates the silly "hit enter to continue"
    #note: doesn't actually seem to do anything in git bash
    system 'clear'
    p "Population Menu"
    p "---------------"
    @analytics.options.each {|opt| p "#{opt[:menu_id]}: #{opt[:menu_title]}"}
  end

  def run
    stop = false

    while(stop != :exit) do
      self.menu
      print "Choice: "
      choice = gets.strip.to_i
      stop = @analytics.run(choice)
      if(stop == :exit)
        p "Exiting."
      else
        print "\nHit enter to continue... "
        gets
      end
    end
  end
end

temp = Population.new
temp.run