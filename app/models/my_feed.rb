class MyFeed < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :feed_id, :user_id, :colour, :categories
  
  attr_accessible :app_url, :from_where
  attr_accessor :app_url, :from_where
  
  #ASSOCIATIONS
  belongs_to :feed, class_name: "Ref::Feed"
  belongs_to :user
  has_many   :tag_entries    , dependent: :destroy
  has_many   :my_entries, dependent: :destroy
  
  #NESTED 
  #VALIDATIONS
  validates :feed_id, presence: true, :if => :if_not_from_ui
  validates :user_id, presence: true
  validates :app_url, presence: true, :if => :if_from_ui
  validate  :no_duplicate_accounts_please, :on => :create
  
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  
  def favicon #google has an api that fetches favicons. :-)
    "https://plus.google.com/_/favicon?domain=#{self.feed.html_url}"
  end
  
  def entity_name
    self.feed.entity_name
  end
  
  def self.create_and_save(akid, uid, cat)
    if akid.blank?
      dfldknfdlknf
    end
    a = MyFeed.where(feed_id: akid, user_id: uid).first
    if a.blank?
      a = MyFeed.new(feed_id: akid, user_id: uid)
    end
    a.categories = cat
    a.save
    return a
  end
  
  def create_and_save_self
    if self.feed_id.blank?
      dfldknfdlknf2
    end
    a = MyFeed.where(feed_id: self.feed_id, user_id: self.user_id).first
    if a.blank?
      self.save
    end
    true
  end
  
  def self.without_tags(u)
    response_obj = []
    u.my_feeds.each do |a|
      if a.tag_entries.first.blank?
        response_obj << a
      end
    end
    return response_obj
  end
    
  #JOBS
  #PRIVATE
  private
  
  def no_duplicate_accounts_please
    a = MyFeed.where(feed_id: self.feed_id, user_id: self.user_id).first
    errors.add(:app_url, "duplicate RSS url") if !a.blank?
    true
  end
  
  def if_from_ui
    self.from_where.blank? ? false : true
  end
  
  def if_not_from_ui
    self.from_where.blank? ? true : false
  end
  
end
