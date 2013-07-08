class Tag < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :name, :sort_id, :sort_order, :user_id
  
  attr_accessible :my_feed_id, :from_where, :current_tag_id
  attr_accessor :my_feed_id, :from_where, :current_tag_id
  
  #ASSOCIATIONS
  belongs_to :user
  has_many :tag_entries
  has_many :my_feeds, through: :tag_entries
  
  #NESTED 
  #VALIDATIONS
  validates :user_id, presence: true
  validates :name, presence: true
  
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  
  def create_and_save_self
    a = Tag.where(name: self.name, user_id: self.user_id).first
    if a.blank?
      self.save
    end
    true
  end
  
  #JOBS
  #PRIVATE
  private
  
end
