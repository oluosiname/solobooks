# frozen_string_literal: true

json_file_path = Rails.root.join('db/currencies.json')
json_data = File.read(json_file_path)
hash_data = JSON.parse(json_data)

Currency.delete_all
hash_data.each do |_key, value|
  Currency.find_or_create_by(
    name: value['name'],
    code: value['code'],
    symbol: value['symbol'],
    active: ['EUR', 'USD'].include?(value['code']),
    default: value['code'] == 'EUR',
  )
end
