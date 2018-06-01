require 'rails_helper'

RSpec.describe 'subscribing:' do
  it 'successfully creates a new contact for user' do
    visit root_path
    expect(page).to have_current_path(root_path)

    fill_in 'Email', with: 'jsmith@example.com'
    click_button 'Subscribe now!'
    expect(page).to have_current_path(contact_path)
    expect(page).to have_css('[data-t-notice-success]')
  end
end
