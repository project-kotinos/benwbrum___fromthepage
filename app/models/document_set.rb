class DocumentSet < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, :use => [:slugged, :history]
  
  attr_accessible :title, :description, :collection_id, :picture, :is_public

  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_user_id'
  belongs_to :collection
  has_and_belongs_to_many :works

  def show_to?(user)
    self.is_public? || self.collection.show_to?(user)
  end
  
  def intro_block
    self.description
  end
  
  def subjects_disabled
    self.collection.subjects_disabled
  end

end
