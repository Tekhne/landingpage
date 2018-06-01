require 'mail'

class Contact < ApplicationRecord
  EMAIL_LENGTH = {
    maximum: 254, # RFCs
    minimum: 3 # a@a
  }.freeze

  RESERVED_EMAIL = [
    'abuse', 'account', 'accounts', 'admin', 'administrator', 'contact',
    'contact-us', 'contactus', 'copyright', 'enquiry', 'faq', 'ftp', 'help',
    'hostmaster', 'imap', 'info', 'localdomain', 'localhost', 'login',
    'logout', 'mail', 'mailer-daemon', 'marketing', 'myaccount', 'news',
    'no-reply', 'nobody', 'noreply', 'payments', 'pop', 'pop3', 'postmaster',
    'preferences', 'pricing', 'privacy', 'profile', 'register', 'root',
    'sales', 'secure', 'security', 'settings', 'signin', 'signup', 'smtp',
    'ssl', 'ssladmin', 'ssladministrator', 'sslwebmaster', 'status',
    'subscribe', 'support', 'sysadmin', 'terms', 'tos', 'user', 'users',
    'webmail', 'webmaster', 'www'
  ].freeze

  validates :email, format: { with: /\A\S+@\S+\z/ }
  validates :email, length: EMAIL_LENGTH
  validate :normalized_email_uniqueness

  # The before_validation callback seems to work better than others for this.
  before_validation :set_normalized_email

  def normalized_email_uniqueness
    return unless self.class.where(normalized_email: normalized_email).exists?
    errors.add(:normalized_email, 'has already been taken')
    errors.add(:email, 'has already been taken')
  end

  def set_normalized_email
    self.normalized_email = email
      .yield_self { |e| normalize_unicode(e) }
      .downcase
      .yield_self { |e| remove_ignored_email_characters(e) }
      .tap { |e| check_reserved_email_addresses(e) }
  end

  private

  def normalize_unicode(email)
    email.unicode_normalize(:nfkc)
  rescue StandardError
    errors.add(:email, 'contains abnormal characters')
    throw :abort
  end

  def remove_ignored_email_characters(email)
    address = parse_email(email)
    return unless address.local && address.domain
    [address.local.delete('.').sub(/\+.*/, ''), address.domain].compact.join('@')
  end

  def check_reserved_email_addresses(email)
    return unless RESERVED_EMAIL.include?(parse_email(email).local)
    errors.add(:email, 'contains a prohibited username')
    throw :abort
  end

  def parse_email(email)
    Mail::Address.new(email)
  rescue StandardError
    errors.add(:email, 'has an abnormal format')
    throw :abort
  end
end
