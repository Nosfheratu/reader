class TagsController < ApplicationController
  
  before_filter :authenticate_user!, :allowed?  

  def create
    if(params[:tag][:from_where] == "from_folder")
    	TagEntry.where(tag_id: params[:tag][:current_tag_id].to_i, my_feed_id: params[:tag][:my_feed_id].to_i).first.delete
    	current_tag = Tag.find_by_id(params[:tag][:current_tag_id].to_i)
    	if(current_tag.tag_entries.count == 0)
    		current_tag.delete
    	end
    end
    @tag = Tag.new(params[:tag])
    flag = true
    if @tag.valid?
      if @tag.create_and_save_self
      	feed_id = MyFeed.find_by_id(@tag.my_feed_id).feed_id
      	my_feed_id = MyFeed.find_by_id(@tag.my_feed_id).id
      	tag_entry_flag = false
    	a = TagEntry.where(feed_id: feed_id, tag_id: @tag.id, my_feed_id: my_feed_id).first
    	if a.blank?
      		tag_entry_flag = TagEntry.create(feed_id: feed_id, tag_id: @tag.id, my_feed_id: my_feed_id)		
    	end
      	if(tag_entry_flag)
        	flag = false
        	redirect_to user_path(current_user), notice: "Feed added to new folder. Please keep refreshing the page."
      	else
      		flag = false
        	redirect_to user_path(current_user), notice: "Request failed. Sorry, we are analyzing the cause of this problem."
      	end
      end
    end
    if flag 
      @home = true
      @is_star = false
      @history = false
      @to_read = false
      @akid = false
      @tags = @user.tags
      @without_tags = MyFeed.without_tags(@user)
      @total_subscriptions = @user.entries_count(nil, nil)
      @entries = MyEntry.by_user(@user).page(params[:page]).per(50)
      flash.now[:error] = "Error: Could not create new folder because #{@tag.errors.messages}"
      render "users/show"
    end
  end

  def move_to_folder
  	if(params[:tag][:from_where] == "from_folder")
    	TagEntry.where(tag_id: params[:tag][:current_tag_id].to_i, my_feed_id: params[:tag][:my_feed_id].to_i).first.delete
    	current_tag = Tag.find_by_id(params[:tag][:current_tag_id].to_i)
    	if(current_tag.tag_entries.count == 0)
    		current_tag.delete
    	end
    end
  	@tag = Tag.new(params[:tag])
    flag = true
    if @tag.valid?
      	feed_id = MyFeed.find_by_id(@tag.my_feed_id).feed_id
      	my_feed_id = MyFeed.find_by_id(@tag.my_feed_id).id
      	tag_id = Tag.where(user_id: @tag.user_id, name: @tag.name).first.id
      	tag_entry_flag = false
    	a = TagEntry.where(feed_id: feed_id, tag_id: tag_id, my_feed_id: my_feed_id).first
    	if a.blank?
      		tag_entry_flag = TagEntry.create(feed_id: feed_id, tag_id: tag_id, my_feed_id: my_feed_id)  		
    	end
      	if(tag_entry_flag)
        	flag = false
        	redirect_to user_path(current_user), notice: "Feed moved to desired folder. Please keep refreshing the page."
      	end
    end
    if flag 
      @home = true
      @is_star = false
      @history = false
      @to_read = false
      @akid = false
      @tags = @user.tags
      @without_tags = MyFeed.without_tags(@user)
      @total_subscriptions = @user.entries_count(nil, nil)
      @entries = MyEntry.by_user(@user).page(params[:page]).per(50)
      flash.now[:error] = "Error: Could not create new folder because #{@tag.errors.messages}"
      render "users/show"
    end
  end

  def update
  	@rename_tag = Tag.find_by_id(params[:id].to_i)
  	update_name = @rename_tag.update_attributes(name: params[:tag][:name])
  	if(update_name == true )
  		redirect_to user_path(current_user), notice: "Folder name has been updated successfully."
  	else
  		redirect_to user_path(current_user), notice: "Request failed. Sorry, we are analyzing the cause of this problem."
  	end
  end

  def edit
  	@first_tag = Tag.find_by_id(params[:tag_id].to_i)
  	respond_to do |format|
  		format.js
  	end
  end

  def destroy
  	tag = Tag.find_by_id(params[:id])
    if tag.present?
      tag.tag_entries.destroy_all
      tag.destroy
    end
    redirect_to user_path(current_user), notice: "Folder deleted successfully. Please keep refreshing the page."
  end

  private
  
  def allowed?
  end
  
end