labels = Rails.application.credentials.dig(:seeds, :labels)
parsed_labels = {}

if labels
  labels.each do |key, attributes|
    parent = parsed_labels.fetch(attributes.fetch(:parent, nil)&.to_s, nil)
    item = Label.where(title: attributes[:title], identifier: attributes[:identifier]).first_or_create!(
      color: attributes.fetch(:color, nil),
      parent: parent
    )
    parsed_labels[key.to_s] = item
  end
else
  puts "No seed data found in credentials"
end
