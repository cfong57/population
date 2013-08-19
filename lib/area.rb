class Area
  attr_accessor :zipcode, :estimated_population, :city, :state
  def initialize(hash)
    @zipcode = hash[:zipcode].to_i || 0
    @estimated_population = hash[:estimated_population].to_i || 0
    @city = hash[:city] || "n/a"
    @state = hash[:state] || "n/a"
  end

  def to_s
    #class variables can be interpolated without @? that's ingenious
    "#{city}, #{state} #{zipcode} has #{estimated_population} people."
  end
end

#derp = Area.new({zipcode: 123123, estimated_population: 4141, city: "herp", state: "murp"})
#p derp.to_s