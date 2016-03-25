require 'sequel'
require 'json'

class Order < Sequel::Model(:orders)
  many_to_one :coffee

  def initialize(options = {})
    super

    self.size = options[:size]
    self.extras = options[:extras]
    self.pickup_time = options[:pickup_time] || Time.now + options[:coffee].brewing_time
  end

  def extras
    JSON.parse(self.extras_list || '[]')
  end

  def extras=(value)
    self.extras_list = JSON.generate(value || [])
  end

  def status
    now = Time.now
    if now > self.pickup_time
      'READY'
    elsif now >= (self.pickup_time - self.coffee.brewing_time)
      'MAKING'
    else
      'QUEUED'
    end
  end
end
