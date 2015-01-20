require 'spec_helper'

describe User do
  it { should have_many(:mentoring_appointments) }
  it { should have_many(:menteeing_appointments) }
  it { should have_many(:availabilities) }
  it { should have_many(:received_kudos) }
  it { should have_many(:given_kudos) }

  it "should show kudos in pretty_name" do
    ryan = User.new(:first_name => "Ryan", :total_kudos => 42)
    ryan.pretty_name.should == "Ryan - 42"
  end

  describe "twitter_handle property" do
    it "should accept valid handles" do
      ryan = User.new(email: 'ryan@example.com', twitter_handle: '9_9_0_reg_x')
      expect(ryan).to be_valid
      expect(ryan.twitter_handle).to eq('9_9_0_reg_x')
    end

    it "should accept a blank field" do
      ryan = User.new(email: 'ryan@example.com')
      expect(ryan).to be_valid
    end

    describe "should not accept an invalid handle" do
      it 'should not accept spaces' do
        ryan = User.new(email: 'ryan@example.com', twitter_handle: 'tweet tweet')
        expect(ryan).to_not be_valid
      end
      it 'should not accept special characters' do
        ryan = User.new(email: 'ryan@example.com', twitter_handle: 'https://ryan')
        expect(ryan).to_not be_valid
      end
      it 'should not accept more than 15 characters' do
        ryan = User.new(email: 'ryan@example.com', twitter_handle: '1234567890123456')
        expect(ryan).to_not be_valid
      end
    end
  end

  describe "email property" do
    it "should accept valid emails" do
      ryan = User.new(email: 'ryan@example.com')
      expect(ryan).to be_valid
      expect(ryan.email).to eq('ryan@example.com')
    end

    it "should not accept a blank field" do
      ryan = User.new
      expect(ryan).to_not be_valid
    end

    describe "should not accept an invalid email" do
      it 'cannot start with a symbol' do
        ryan = User.new(email: '@example.com')
        expect(ryan).to_not be_valid
      end
      it 'cannot have spaces' do
        ryan = User.new(email: 'ryan @example.com')
        expect(ryan).to_not be_valid
      end
      it 'cannot have invalid domain' do
        ryan = User.new(email: 'ryan@example.x')
        expect(ryan).to_not be_valid
      end
      it 'must have @ symbol' do
        ryan = User.new(email: 'ryanexample.com')
        expect(ryan).to_not be_valid
      end
    end
  end
end
