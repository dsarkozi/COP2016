# Class UtilsTests in module Utils
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Utils

  # It generate different data between ranges
  class UtilsTests
    
    def self.generate_number_in(range)
      prng = Random.new
      prng.rand(range)
    end

    def self.generate_degree
      generate_number_in(-40.0..40.0).round(1)
    end

    def self.vary_degree(degree)
      generate_number_in(degree-2..degree+2).round(1)
    end

    def self.generate_gps_data
      [generate_number_in(-90.0...90.0).round(6), 
        generate_number_in(-180.0...180.0).round(6)]
    end

    def self.vary_gps_data(lat, long)
      [generate_number_in(lat-5...lat+5).round(6), 
        generate_number_in(long-5...long+5).round(6)]
    end

  end
end