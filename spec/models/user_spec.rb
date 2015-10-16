describe User do

  before(:each) { @user = User.new(email: 'user@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match 'user@example.com'
  end

  it "calculates donation amount given an amount" do
  	
  	expect(@user.calculate_application_fee).to match '1'
  end

end
