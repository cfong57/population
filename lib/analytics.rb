class Analytics
  attr_accessor :options
  def initialize(areas)
    @areas = areas
    set_options
  end

  #in my opinion, this "GUI" stuff belongs in a separate file, as it's unrelated to "analyzing"
  def set_options
    @options = []
    @options << {menu_id: 1, menu_title: "Areas count", method: :how_many}
    @options << {menu_id: 2, menu_title: "Smallest population (non-zero)", method: :smallest_pop}
    @options << {menu_id: 3, menu_title: "Larest population", method: :largest_pop}
    @options << {menu_id: 4, menu_title: "How many zips in California?", method: :california_zips}
    @options << {menu_id: 5, menu_title: "Information for a given zip", method: :zip_info}
    @options << {menu_id: 6, menu_title: "Exit", method: :exit}
  end

  def run(choice)
    #could maybe avoid .first by setting menu_id equal to the option's index in @options array
    opt = @options.select {|x| x[:menu_id] == choice}.first
    if opt.nil?
      p "Invalid choice '#{choice}'."
    elsif opt[:method] != :exit
      self.send(opt[:method])
      :done
    else
      opt[:method]
    end
  end

  def how_many
    p "There are #{@areas.length} areas."
  end

  def smallest_pop
    sorted = @areas.sort {|x, y| x.estimated_population <=> y.estimated_population}
    #drop_while works because we already sorted; delete_if doesn't require that
    smallest = sorted.drop_while {|i| i.estimated_population == 0}.first
    p "#{smallest.city}, #{smallest.state} has the smallest population of #{smallest.estimated_population}."
  end

  def largest_pop
    sorted = @areas.sort {|x, y| x.estimated_population <=> y.estimated_population}
    #drop_while works because we already sorted; delete_if doesn't require that
    #...also, not sure why we're dropping in the first place - a proper sort should put the largest at .first or .last
    largest = sorted.reverse.drop_while {|i| i.estimated_population == 0}.first
    p "#{largest.city}, #{largest.state} has the largest population of #{largest.estimated_population}."
  end

  def california_zips
    c = @areas.count {|a| a.state == "CA"}
    p "There are #{c} zip code matches in California."
  end

  def zip_info
    print "Enter zip: "
    zip = gets.strip.to_i
    zips = @areas.select {|a| a.zipcode == zip}
    unless zips.empty?
      p ""
      zips.each {|z| p z}
    else
      p "Zip not found."
    end
  end
end