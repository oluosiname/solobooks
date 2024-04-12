# frozen_string_literal: true

if Rails.env.development?
  Invoice.destroy_all
  Client.delete_all
  Address.delete_all
end
