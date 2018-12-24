require './Car_maker'

#Car_model subclass of Car_maker

class Car_model < Car_maker

  #accessors
  attr_accessor :km, :type, :transmission, :stock, :driveTrain, :status, :fuelEconomy, :car_maker, :model, :year, :trim, :set_of_features

  #static variable to count the number of instances
  @@total = 0

  #constructor
  def initialize(km, type, transmission, stock ,driveTrain, status, fuelEconomy, car_maker, model, year, trim, set_of_features)

    #gets constructor of parent class
    super (car_maker)

    #updating the number of instances
    @@total += 1

    #instance variables
    @km = km
    @type = type
    @transmission = transmission
    @stock = stock
    @driveTrain = driveTrain
    @status = status
    @fuelEconomy = fuelEconomy
    @model = model
    @year = year
    @trim = trim
    @set_of_features = set_of_features

  end

  #return the number of models
  def Car_model.total
    return "Number of car models : #@@total"

  end

  @fileObj = File.new("listingFeatures.txt", "r")

  #array that will store all the object created, used in the searching routine
  @@catalogue = []

  #remove comma at the end of the string
  def remove_trailing_comma(str)
    str.nil? ? nil : str.chomp(",")
  end


  def self.convertListings2Catalougue(line)


    type_array = %w(sedan coupe hatchback station suv)
    transmission_array = %w(auto  manual  steptronic)
    driveTrain_array = %w(fwd rwd awd)
    status_array = %w(used  new)
    car_maker_array = %w(honda  toyota  mercedes  bmw  lexus)

    array_of_features = []
    counter_word = 0
    #hash that will store the components of each object
    hash = Hash.new



      puts "Main String : #{line}"

    #separating the set of features between curly parentheses from the rest

    curly_Parenthesis = line[/{(.+)}/, 1]
    set_of_features = curly_Parenthesis.split(/,/)
    set_of_features.each do |s|
      array_of_features.push(s)
    end
    puts "set of features : #{array_of_features}"
    #storing the features in the hash
    hash["Set of features"] = array_of_features

    #creating the rest of the string (without content of curly parenthesis) named substring
    substring = line.gsub(/\{.+\}/, '')

    #removing comma at the end of the string
    substring = substring.chomp

    puts "Sub String : #{substring}"

    #splitting the substring creates an array of each particular string
    words = substring.split(/,/)


    #when we create the substring by removing the { } we will have that case " something , , something else " so we remove empty space
    words = words.reject{|empty| empty.empty?}
    puts "after removing empty spaces #{words}"

    words.each do |w|
      w = w.chomp

      counter_word = counter_word + 1
      km = "km"
      char = "/"

      if w.include?(char) and w.include?(km)
        hash["Fuel economy"] = w
        puts "Fuel economy : #{w}"

      elsif /(?=.*[a-zA-Z])(?=.*[0-9])/.match(w) and !w.include?(km)
        hash["#Stock"] = w
        puts "#stock : #{w}"


      elsif w.include?(km) and !w.include?(char)
        hash["Km"] = w
        puts "km : #{w} "


      elsif type_array.include?(w.downcase)
        hash["Type"] = w
        puts "type : #{w}"


      elsif transmission_array.include?(w.downcase)
        hash["Transmission"] = w
        puts "transmission : #{w}"


      elsif driveTrain_array.include?(w.downcase)
        hash["Drive train"] = w
        puts "drive train : #{w}"


      elsif status_array.include?(w.downcase)
        hash["Status"] = w
        puts "status : #{w}"


      elsif car_maker_array.include?(w.downcase)
        hash["Car maker"] = w
        puts "car maker : #{w}"


      elsif w.length == 2
        hash["Trim"] = w
        puts "trim : #{w}"


      elsif /\A\d+\z/.match(w)
        hash["Year"] = w
        puts "year : #{w}"

      else
        hash["Model"] = w
        puts"model : #{w}"

      end

      end


    return hash

  end



  #searching routine
  def  self.searchInventory(hash)

    @@catalogue.each do |o|

      if o.car_maker == hash["Car maker"]
        puts("#{o.car_maker},#{o.model},#{o.km},#{o.year},#{o.type},#{o.driveTrain},#{o.transmission},#{o.stock},#{o.status},#{o.fuelEconomy},#{o.set_of_features}")
      end

    end

  end


  #adding new line for car

  def self.add2Inventory(newList)

    #we append to file and go back to a new line(write, puts... deletes everything and add the line)
    File.open("listingFeatures.txt", "a") { |file| file << newList + "\n"}

    #add it to catalogue (check if i need to call it from here????)
    result2 = convertListings2Catalougue(newList)

    puts "Hash : #{result2}"



    #creating each object
    object= Car_model.new(result2["Km"],result2["Type"],result2["Transmission"],result2["#Stock"],result2["Drive train"], result2["Status"], result2["Fuel economy"], result2["Car maker"], result2["Model"], result2["Year"], result2["Trim"], result2["Set of features"])

    #storing the object in our catalogue
    @@catalogue.push (object)

  end


  #saving the object in the reorganized file

  def self.saveCatalogue2File()

    #sort alphabetically by car maker
    @@catalogue.sort_by!{|carMaker| carMaker.car_maker}

     newFile = File.open("reorganizedFile.txt", "w")

      @@catalogue.each do |o|
        newFile.puts("#{o.car_maker},#{o.model},#{o.trim},#{o.km},#{o.year},#{o.type},#{o.driveTrain},#{o.transmission},#{o.stock},#{o.status},#{o.fuelEconomy},#{o.set_of_features}")
      end


  end

  @fileObj.each_line{|line|
      #testing 1st method
      result = convertListings2Catalougue(line)
      puts "Hash : #{result}"
      puts "hash size : #{result.length}"

    #creating each object
    object= Car_model.new(result["Km"],result["Type"],result["Transmission"],result["#Stock"],result["Drive train"], result["Status"], result["Fuel economy"], result["Car maker"], result["Model"], result["Year"], result["Trim"], result["Set of features"])

    #storing the object in our catalogue
    @@catalogue.push (object)

  }

  # testing add
  test = "coupe,11324100km,auto,RWD,Toyota,CLK,LX,18FO724A,2017,{Keyless Entry,Power seats},6L/100km,Used"
  add2Inventory(test)


  # prints our catalogue and number of instance
  puts "catalogue #{@@catalogue}"
  puts Car_model.total



  #testing searching routine
  hash2 = {"Car maker" => "Toyota"}

  searchInventory(hash2)

  puts hash2["Car maker"]


  saveCatalogue2File

  @fileObj.close

end

