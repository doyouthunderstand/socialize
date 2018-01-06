class User < ApplicationRecord
    attr_accessor :password, :activation_token
    validates_presence_of :first_name, :last_name, :email, :password
    validates :password, :confirmation => :true
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    validates :email, uniqueness: true
    before_save :encrypt_password
    before_create { generate_token(:auth_token) }
    before_create :create_activation_digest
    after_save :clear_password

    def encrypt_password
        if password.present?
            self.salt = BCrypt::Engine.generate_salt
            self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
        end
    end

    def clear_password
        self.password = nil
    end

    def self.authenticate(login_email="", login_password="")
        user = User.find_by_email(login_email)
        if user && user.match_password(login_password)
            return user
        else
            return false
        end
    end

    def match_password(login_password="")
        encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
    end

    def generate_token(column)
        begin
            self[column] = SecureRandom.urlsafe_base64
        end while User.exists?(column => self[column])
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token 
        SecureRandom.urlsafe_base64
    end

    private #Can likely refactor later to add other methods to private

    def create_activation_digest
        #Can likely refactor to remove new_token method and use generate_token later
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
