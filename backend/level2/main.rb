require 'json'
require 'date'

# quick one liners, never fails, no error handling
expected_output_hash = JSON.parse(File.read('./data/expected_output.json'))
input_hash = JSON.parse(File.read('./data/input.json'))

# this is not perfect, but it works fine.
def days_price(days, price_per_day)
  price = 0
  while days > 0
    if days > 10
      cheaper_days = days - 10
      price += 0.5 * price_per_day * (days -10)
      days = 10
    elsif days > 4
      price += 0.7 * price_per_day * (days -4)
      days = 4
    elsif days > 1
      price += 0.9 * price_per_day * (days - 1)
      days = 1
    else # == 1
      price += price_per_day
      days = 0 # loop out
    end
  end
  price.to_i # to_i useless
end

processed_input = {
 'rentals' => input_hash['rentals'].map do |rental|
    car = input_hash['cars'].find { |car| car['id'] == rental['car_id'] }
    # no round, no floor, go straight
    # + 1 because all days inclusive
    number_of_days = ( Date.parse(rental['end_date']) - Date.parse(rental["start_date"])).to_i  + 1
    {
      'id' => rental['id'],
      'price' => days_price(number_of_days, car['price_per_day'])  + car['price_per_km'] * rental['distance']
    }
  end
}

# if processed_input == expected_output_hash
#   p "Succcess"
# else
#   p "Failure"
#   # quick debug
#   p "Input hash:"
#   pp input_hash
#   p "Expected output:"
#   pp expected_output_hash
#   p "Processed input"
#   pp processed_input
# end

pp processed_input

