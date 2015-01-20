feature "mentee create an appointment" do
  context "when mentee enter provide valid inputs" do






describe "#new"
  it 'rerenders the form if user does not input valid email or twitter' do
      user = FactoryGirl.create(:mentor, :activated => false)
      fill_in :first_name, with: "mike"
      fill_in :last_name, with: "bike"
      fill_in 'Twitter handle ', with: "mike-bike"
      fill_in 'Email address ', with: "mike@example.com"
      click_button "Submit"
      expect(page).to have_content('is invalid')
    end
