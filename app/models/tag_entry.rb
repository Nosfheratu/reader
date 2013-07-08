class TagEntry < ActiveRecord::Base
  
  #GEMS USED
  #ACCESSORS
  attr_accessible :my_feed_id, :tag_id, :feed_id
  
  #ASSOCIATIONS
  belongs_to :my_feed
  belongs_to :tag
  
  #NESTED 
  #VALIDATIONS
  validates :my_feed_id, presence: true
  validates :tag_id, presence: true
  
  #CALLBACKS  
  #SCOPES  
  #OTHER METHODS
  def self.import(akid, tgid)
    a = TagEntry.where(my_feed_id: akid, tag_id: tgid).first
    if a.blank?
      TagEntry.create(my_feed_id: akid, tag_id: tgid)
    end
  end
  
  #JOBS
  #PRIVATE
  private
  
end
