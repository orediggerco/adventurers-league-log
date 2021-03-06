require 'rails_helper'

RSpec.feature 'Character Log Entries', type: :feature do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login_as(@user, scope: :user)
    @character = FactoryGirl.create(:character, user: @user, name: 'Test Character')
    @adventure = FactoryGirl.create(:adventure, name: 'Lost Mines of Phandelver')
  end

  context 'When a user creates a DM Log Entry' do
    before(:each) do
      @locations_count = Location.count
      visit user_dm_log_entries_path(@user)

      # click_link 'New Entry'
      all('a', text: 'New Entry').first.click

      within('#dm-log-entry-main-form') do
        fill_in 'Adventure Title', with: 'Lost Mines of Phandelver'

        fill_in 'Session',            with: '22'
        fill_in 'Date DMed',          with: '' #Hack for calendar popout
        fill_in 'Date DMed',          with: '2016-08-01 19:00'

        fill_in 'Length (Hours)',     with: '8'
        fill_in 'Player Level',       with: '7'
        fill_in 'XP Gained',          with: '1001'
        fill_in 'GP +/-',             with: '333'
        fill_in 'Downtime +/-',       with: '111'
        fill_in 'Renown',             with: '44'
        fill_in 'Mission',            with: '55'
        fill_in 'Location',           with: 'Origins'
        fill_in 'Notes',              with: 'Some Words'

        fill_in 'Date Assigned',      with: '' #Hack for calendar popout
        fill_in 'Date Assigned',      with: '2017-08-01 12:00'
        select  'Test Character',     from: 'Character to Apply Rewards'
      end

      click_button 'Save'
    end

    it 'should create a location' do
      expect(Location.count).to have_text(@locations_count + 1)

      visit user_locations_path(@user)

      expect(page).to have_text('Origins')
    end
  end
end
