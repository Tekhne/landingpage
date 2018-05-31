require 'rails_helper'
require_relative '../support/custom_matchers/models'

RSpec.describe Contact, type: :model do
  let(:contact) { build(:contact) }
  let(:contact2) { build(:contact, email: contact.email.upcase) }

  context 'validations' do
    it 'ensures email format is valid' do
      expect(contact).to be_valid
      contact.email = 'invalid'
      expect(contact).to be_invalid_for(:email)
    end

    it 'ensures email length is >= EMAIL_LENGTH[:minimum]' do
      invalid_email = 'a' * (Contact::EMAIL_LENGTH[:minimum] - 1)
      contact.email = invalid_email
      expect(contact).to be_invalid_for(:email)
    end

    it 'ensures email length is <= EMAIL_LENGTH[:maximum]' do
      invalid_domain = 'a' * Contact::EMAIL_LENGTH[:maximum]
      invalid_email = "a@#{invalid_domain}.com"
      contact.email = invalid_email
      expect(contact).to be_invalid_for(:email)
    end

    it 'ensures normalized_email is unique' do
      contact.save!
      contact2.email = contact.email
      expect(contact2).to be_invalid_for(:normalized_email)
      expect(contact2).to be_invalid_for(:email)
    end
  end

  context 'callbacks' do
    context '.before_validation' do
      describe '#set_normalized_email' do
        it 'sets normalized_email from Unicode normalized email' do
          contact.email = "a\u0300@example.com"
          contact.validate
          expect(contact.normalized_email).to \
            eq("\u00E0@example.com")
        end

        it 'sets normalized_email from downcased email' do
          contact.normalized_email = nil
          contact.email = 'SMITH@example.com'
          contact.validate
          expect(contact.normalized_email).to \
            eq('smith@example.com')
        end

        it 'sets normalized_email from email without ignored characters' do
          contact.email = 'first.last+tag@example.com'
          contact.validate
          expect(contact.normalized_email).to \
            eq('firstlast@example.com')
        end

        it 'invalidates normalized_email when email uses reserved addresses' do
          reserved_local = Contact::RESERVED_EMAIL.first
          contact.email = "#{reserved_local}@example.com"
          expect(contact).to be_invalid_for(:email)
        end
      end
    end
  end
end
