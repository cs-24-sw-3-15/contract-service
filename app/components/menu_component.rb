# frozen_string_literal: true

class MenuComponent < ViewComponent::Base
  def initialize(location:)
    @location = location
  end
end
