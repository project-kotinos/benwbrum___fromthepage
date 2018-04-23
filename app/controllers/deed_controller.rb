class DeedController < ApplicationController

  PAGES_PER_SCREEN = 50

  def list
    #get rid of col_id if no breadcrumbs
    remove_col_id
    
    condition = []

    if @collection
      condition = ['collection_id = ?', @collection.id]
    elsif @user
      condition = ['user_id = ?', @user.id]
    elsif @collection_ids
      @deeds = Deed.where(collection_id: @collection_ids).order('created_at DESC').paginate :page => params[:page], :per_page => PAGES_PER_SCREEN
      return
    else
      # display only deeds on collections the current user can see
      if current_user
        condition = ['collections.restricted = false OR collection_id in (?)', current_user.collection_collaborations.pluck(:id) + current_user.collections.map { |c| c.id }]
      else
        condition = ['collections.restricted = false']
      end
    end
    
    @deeds = Deed.joins(:collection).where(condition).order('created_at DESC').paginate :page => params[:page], :per_page => PAGES_PER_SCREEN
  end

end
