# frozen_string_literal: true

class Feed < ApplicationRecord
  scope :default_order, -> { order(created_at: :desc) }
end
