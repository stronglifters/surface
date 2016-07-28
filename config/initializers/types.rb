require 'quantity_type'
ActiveRecord::Type.register(:quantity, QuantityType)
