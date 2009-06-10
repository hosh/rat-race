require File.dirname(__FILE__) + '/../../spec_helper'

describe Lead do
  # Class variable used so we can iterate over the attributes to specify required fields
  @@valid_attributes = {
    :entity_id          => 'some_id',
    :entity_type_id      => '0',
    :session_id         => 'some_id',
    :website           => 'example.com',
    :first_name        => 'some_name',
    :last_name         => 'some_name'
  }

  before do
    @lead = Lead.new(@@valid_attributes.merge(:email => "me@example.com"))
  end
  
  describe "with valid attributes" do
    it { @lead.should be_valid }
  end
  
  @@valid_attributes.keys.each do |attribute|
    it "should require #{attribute}" do
      @lead.send "#{attribute}=", nil
      @lead.should_not be_valid
    end
  end
  
  describe "without email or phone" do
    before { @lead.email = @lead.phone = nil }
    
    it { @lead.should_not be_valid }
    
    it "is valid with an email" do
      @lead.email = "me@example.com"
      @lead.should be_valid
    end
    
    it "is valid with a phone" do
      @lead.phone = "4045551212"
      @lead.should be_valid
    end
  end
  
  it "requires a valid phone number" do
    %w( 12345678901 123467890 ).each do |invalid_phone_number|
      @lead.phone = invalid_phone_number
      @lead.should_not be_valid
    end
  end  
  
  it "strips non-digits from the phone numbers before validation" do
    %w( (123)\ 456-7890 123-456-7890 ).each do |valid_phone_number|
      @lead.phone = valid_phone_number
      @lead.should be_valid
    end
  end
  
  it "requires a valid email address" do
    %w( example.com foo\ bar@example.com foo@ ).each do |invalid_email|
      @lead.email = "valid@example.com"
      @lead.should be_valid
      
      @lead.email = invalid_email
      @lead.should_not be_valid
    end
  end  
  
  it "replaces a nil lead_type_id with 0" do
    @lead.lead_type_id = nil
    @lead.save
    @lead.lead_type_id.should == 0
  end
  
  it "replaces an empty lead_type_id with 0" do
    @lead.lead_type_id = ''
    @lead.save
    @lead.lead_type_id.should == 0
  end 
end
