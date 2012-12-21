# class Row
#   def initialize(row)
#     row.each do |k,v|
#       self.class.send(:define_method, k.to_sym, lambda { v })
#     end
#   end
# end
# 
# module ActsAsCsv
#   def self.included(base)
#     base.extend ClassMethods
#   end
# 
#   module ClassMethods
#     def acts_as_csv
#       include InstanceMethods
#     end
#   end
# 
#   module InstanceMethods
#     def read
#       @csv_contents = []
#       filename = self.class.to_s.downcase + '.txt'
#       file = File.new(filename)
#       @headers = file.gets.chomp.split(', ')
# 
#       file.each do |row|
#         @csv_contents << row.chomp.split(', ')
#       end
#     end
# 
#     def each
#       @csv_contents.each do |row|
#         yield Row.new(Hash[@headers.zip row])
#       end
#     end
# 
#     attr_accessor :headers, :csv_contents
#     def initialize
#       read 
#     end
#   end
# end
# 
# class RubyCsv  # no inheritance! You can mix it in
#   include ActsAsCsv
#   acts_as_csv
# end
# 
# csv = RubyCsv.new
# csv.each { |row| puts row.one }  # test new each method

class Hash
  def method_missing name, *args
    self[name.to_s]
  end
end

module ActsAsCsv
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @csv_contents = []
      filename = self.class.to_s.downcase + '.txt'
      file = File.new(filename)
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @csv_contents << row.chomp.split(', ')
      end
    end

    def each
      @csv_contents.each do |row|
        yield Hash[@headers.zip row]
      end
    end

    attr_accessor :headers, :csv_contents
    def initialize
      read 
    end
  end
end

class RubyCsv  # no inheritance! You can mix it in
  include ActsAsCsv
  acts_as_csv
end

csv = RubyCsv.new
csv.each { |row| puts row.one }  # test new each method
