class ApplicationService
  attr_accessor :errors, :success

  def initialize(*)
    @errors = []
    @success = false
  end

  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    raise NotImplementedError, "You must implement the #call method in #{self.class}"
  end
end
