require 'sequel'
require 'json'
require_relative 'coffee'

module Models
  class Order < Sequel::Model(:orders)
    many_to_one :coffee

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

    plugin :validation_helpers

    VALID_SIZES = %w(small medium large)

    def before_create
      if self.pickup_time < Time.now + self.coffee.brewing_time
        errors.add(:pickup_time, 'is earlier than minimum brewing time')
        raise Sequel::ValidationFailed.new(errors)
      end
    end

    def before_validation
      if self.coffee && !self.pickup_time
        self.pickup_time = Time.now + self.coffee.brewing_time + 10
      end
    end

    def validate
      super
      validates_type Models::Coffee, :coffee
      validates_schema_types [:size, :extras_list, :pickup_time]
      validates_includes VALID_SIZES, :size
    end
  end
end
