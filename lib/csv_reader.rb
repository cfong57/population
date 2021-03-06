#you know, Ruby already has a handy library for this, called csv
#http://rubydoc.info/stdlib/csv
#require 'csv'

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
    gsub(/([a-z\d])([A-Z])/, '\1_\2').
    tr("-", "_").
    downcase
  end
end

class CSVReader
  attr_accessor :fname
  #the setter method is being overridden anyway
  attr_reader :headers

  def initialize(filename)
    @fname = filename.to_s
  end

  def headers=(string)
    @headers = string.split(",")
    @headers.map! do |x|
      x.gsub!("\"", "")
      x.strip!
      x.underscore.to_sym
    end
  end

  def create_hash(array)
    #requires scrubbed input, a clean array of strings

    #another way to do this would be to build the hash like...
    #@headers.each do |head|
    #  array.each do |ary|
    #    ary.to_s.strip.gsub("\"", "")
    #    hash[head] = ary unless ary.empty?
    #
    #...but bloc hasn't covered nested loops (yet?), and it's probably less efficient

    hash = {}
    @headers.each_with_index do |header, index|
      value = array[index].strip.gsub("\"", "")
      hash[header] = value unless value.empty?
    end
    hash
  end

  def read
    f = File.new(@fname, "r")
    self.headers = f.readline

    while (!f.eof? and next_line = f.readline)
      values = next_line.split(",")
      #ok, now I see how it's being done. technically don't need any cleanup code, but it's still not super fault-tolerant
      hash = create_hash(values)
      yield(hash)
    end
  end
end

#p "CamelCaseString".underscore 
#csv = CSVReader.new("herp.rb")
#csv.headers = '"RecordNumber","Zipcode","ZipCodeType","City","State","LocationType","Lat","Long","Xaxis","Yaxis","Zaxis","WorldRegion","Country","LocationText","Location","Decommisioned","TaxReturnsFiled","EstimatedPopulation","TotalWages","Notes"'
#p csv.headers
#p csv.create_hash(["1","00704","STANDARD","PARC PARQUE","PR","NOT ACCEPTABLE","17.96","-66.22","0.38","-0.87","0.30","NA","US","Parc Parque, PR","NA-US-PR-PARC PARQUE","false","","","",""])
#unclean: 1,"00704","STANDARD","PARC PARQUE","PR","NOT ACCEPTABLE",17.96,-66.22,0.38,-0.87,0.30,"NA","US","Parc Parque, PR","NA-US-PR-PARC PARQUE","false",,,,