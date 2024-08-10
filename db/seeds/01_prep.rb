# frozen_string_literal: true

if Rails.env.development?
  Invoice.destroy_all
  Client.delete_all
  # Address.where.not(addressable_type: 'User').delete_all
end
