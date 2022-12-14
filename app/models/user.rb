class User < ApplicationRecord
    include SessionsHelper

    attr_accessor :remember_token, :activation_token, :reset_token
    before_create :create_activation_digest
    before_save { self.email = email.downcase }

    validates :name, presence: true, length: {maximum: 255}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: {maximum: 255}, 
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: { case_sensitive: false }
    has_secure_password
    mount_uploader :avatar, AvatarUploader
    validates :password, presence: true, length: { minimum: 6 }
    validates :phone, presence: true
    validates :address, presence: true

    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy

    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    
    #Relation ship with shop
    has_one :shop 

    has_many :cart_sessions
    has_many :orders

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # Forgets a user.
    def forget
        update_attribute(:remember_digest, nil)
    end

    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # Activates an account.
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
    
    # Sends activation email.
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    #Sends order details to customer
    def send_customer_order_email
        UserMailer.customer_order(self).deliver_later
    end

    # Returns true if a password reset has expired.
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    # Follows a user.
    def follow(other_user)
        following << other_user
    end
    # Unfollows a user.
    def unfollow(other_user)
        following.delete(other_user)
    end
    # Returns true if the current user is following the other user.
    def following?(other_user)
        following.include?(other_user)
    end

    def feed
        shop_ids = "select id from Shops where user_id in (select followed_id from Relationships where follower_id = #{id})"
        Product.where("shop_id IN (#{shop_ids})").limit(8)
    end

    private
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
