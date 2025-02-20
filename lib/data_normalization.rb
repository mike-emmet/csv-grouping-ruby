# Data normalization for consistent matching
# Handles edge cases in phone/email formatting

# Convert phone numbers to standardized format
def normalize_phone(phone)
  return nil if phone.nil? || phone.strip.empty?

  # Strip non-digits and handle US country code
  cleaned_phone = phone.gsub(/[^0-9]/, '')
  cleaned_phone.length == 11 && cleaned_phone.start_with?('1') ? cleaned_phone[1..-1] : cleaned_phone
end

# Standardize email formatting
def normalize_email(email)
  return nil if email.nil? || email.strip.empty?

  # Normalize case and whitespace
  email.strip.downcase
end
