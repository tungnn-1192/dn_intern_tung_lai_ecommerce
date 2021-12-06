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

RSpec.shared_examples ".currency_attributes" do
  it "should returns currency attributes" do
    expect(subject.class).to respond_to(:currency_attributes)
    attributes = subject.class.currency_attributes
    attributes.each do |attribute|
      expect(subject.send(attribute)).to be_kind_of(Numeric)
    end
  end
end
