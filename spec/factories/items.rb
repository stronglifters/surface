FactoryGirl.define do
  factory :item do
    name FFaker::Name.name
    description FFaker::HipsterIpsum.words(50)
    serial_number SecureRandom.uuid
    purchase_price { (rand(1_000) + rand).round(2) }
    purchased_at DateTime.now
  end
end
