require 'json'
require 'date'

# quick one liners, never fails, no error handling
expected_output_hash = JSON.parse(File.read('./data/expected_output.json'))
input_hash = JSON.parse(File.read('./data/input.json'))

processed_input = {
 'rentals' => input_hash['rentals'].map do |rental|
    car = input_hash['cars'].find { |car| car['id'] == rental['car_id'] }
    # no round, no floor, go straight
    # + 1 because all days inclusive
    number_of_days = ( Date.parse(rental['end_date']) - Date.parse(rental["start_date"])).to_i  + 1
    {
      'id' => rental['id'],
      'price' => car['price_per_day'] * number_of_days + car['price_per_km'] * rental['distance']
    }
  end
}

if processed_input == expected_output_hash
  p "Succcess"
else
  p "Failure"
  # quick debug
  p "Input hash:"
  pp input_hash
  p "Expected output:"
  pp expected_output_hash
  p "Processed input"
  pp processed_input
end
