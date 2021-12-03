RSpec.shared_examples ".datetime_attributes" do
  it "should returns datetime attributes" do
    expect(subject.class).to respond_to(:datetime_attributes)
    attributes = subject.class.datetime_attributes
    attributes.each do |attribute|
      expect([Date, ActiveSupport::TimeWithZone])
        .to include(subject.send(attribute).class)
    end
  end
end
