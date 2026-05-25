class User < ApplicationRecord
  # First phase keeps authentication minimal: password login plus password recovery.
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Roles stay intentionally small for now; Pundit builds on top of this distinction.
  enum role: {
    user: 'user',
    admin: 'admin'
  }

  # Status is separate from role so an admin can still be disabled without changing privileges.
  enum status: {
    active: 'active',
    disabled: 'disabled'
  }

  validates :role, presence: true, inclusion: { in: roles.keys }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  def active_for_authentication?
    # Devise calls this hook before sign-in and on authenticated requests.
    super && active?
  end

  def inactive_message
    # Return a custom key so the UI can explain that access was blocked by account status.
    active? ? super : :disabled
  end
end
