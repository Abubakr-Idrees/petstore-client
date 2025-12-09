module PetstoreClient
  class Client
    attr_reader :configuration, :pet, :store

    def initialize(config = nil)
      @configuration = config || Configuration.new
      yield(@configuration) if block_given?
      
      @pet = Api::PetApi.new(@configuration)
      @store = Api::StoreApi.new(@configuration)
    end

    def self.configure
      config = Configuration.new
      yield(config)
      new(config)
    end
  end
end
