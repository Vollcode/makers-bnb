feature 'Create new accommodation' do

  context 'When logged in' do

    let(:user) do
      User.create(name: 'Michael',
                  email: 'michael@test.com',
                  password: 'password',
                  password_confirmation: 'password')
    end

    before { login email: user.email, password: user.password }

    scenario 'Saves new accommodation to database' do
      fill_in_new_accom_form
      expect{ click_button 'Create Accommodation' }.to change(Accommodation, :count).by 1
      expect(Accommodation.first.name).to eq 'Michael\'s House'
      expect(Accommodation.first.desc).to eq 'Cool place'
      expect(Accommodation.first.price).to eq 50.0

      expect(current_path).to eq '/accommodations'
    end

    scenario 'should show up on the accommodations page' do
      create_new_accom
      expect(page).to have_content "Michael's House £50"
    end

    scenario 'should redirect to specific accommodation page when clicked on link' do
      create_new_accom
      click_on "Michael's House"
      expect(current_path).to eq "/accommodations/#{Accommodation.first.id}"
      expect(page).to have_content "Cool place"
    end


    describe 'Mandatory fields' do
      scenario 'name is mandatory' do
        expect{ create_new_accom(name: nil) }.not_to change(Accommodation, :count)
        expect(current_path).to eq '/accommodations/new'
      end

      scenario 'price is mandatory' do
        expect{ create_new_accom(price: nil) }.not_to change(Accommodation, :count)
        expect(current_path).to eq '/accommodations/new'
      end

      scenario 'price must be a number' do
       expect{ create_new_accom(price: 'five') }.not_to change(Accommodation, :count)
       expect(current_path).to eq '/accommodations/new'
      end

      scenario 'price cannot less than 1' do
        expect{ create_new_accom(price: 0) }.not_to change(Accommodation, :count)
        expect(current_path).to eq '/accommodations/new'
      end
    end
    context 'When availability is managed' do

      scenario 'a range of dates can be picked' do
        expect{ create_new_accom }.to change(Inventory, :count).by(2)
      end
    end
  end

  context 'When logged out' do
    scenario 'Can\'t create a listing' do
      visit 'accommodations/new'
      expect(page).to have_content('Please Log In')
      expect(page).not_to have_css('form#create-accommodation')
    end
  end
end
