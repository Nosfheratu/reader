class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  
  def admin
    if !@user.is_admin?
      redirect_to user_path(current_user)
    end
    @users = User.order("last_sign_in_at desc")
    @total_subscriptions = MyFeed.count
    @total_articles = MyEntry.count
    @total_history = MyEntry.read.count
    @total_star = MyEntry.star.count
    @total_to_read = MyEntry.to_read.count
    @response_obj = []
    @users.each do |u|
      @response_obj << [u, u.my_feeds.count, u.entries_count(nil, nil), u.entries_count('h' , nil), u.entries_count('s' , nil), u.entries_count('r', nil)]
    end
  end
  
  def job
    if !@user.is_admin?
      redirect_to user_path(current_user)
    end
    @total_history = @user.entries_count('h' , nil)
    @delayedjobs = DelayedJob.page(params[:page]).per(50)
  end
  
  def show
    @tags = @user.tags
    @without_tags = MyFeed.without_tags(@user)
    @my_feed = MyFeed.new
    @total_subscriptions = @user.entries_count(nil, nil)
    if !params[:entry].blank?
      @feed_article = MyEntry.find(params[:entry])
      @feed_article.update_attributes(is_to_read: false, last_clicked_on: Time.now)
    end
    @is_star = params[:s]
    @history = params[:h]
    @to_read = params[:r]
    @akid = params[:akid]
    @home = (params[:r].blank? and params[:h].blank? and params[:s].blank? and params[:akid].blank?) ? true : false 
    if !params[:h].blank?
      @entries = MyEntry.read.by_user(@user).page(params[:page]).per(50)
    elsif !params[:r].blank?
      @entries = MyEntry.to_read.by_user(@user).page(params[:page]).per(50)
    elsif !params[:s].blank?
      @entries = MyEntry.star.by_user(@user).page(params[:page]).per(50)
    elsif !params[:akid].blank?
      @entries = MyEntry.where("my_entries.my_feed_id = ?", params[:akid]).page(params[:page]).per(50)
    else
      @entries = MyEntry.by_user(@user).page(params[:page]).per(50)
    end
  end
    
  def edit
    @menu = "set"
    @total_history = @user.entries_count('h' , nil)
  end
  
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, flash: {notice: t("updation.success")}
    else
      @total_history = @user.entries_count('h' , nil)
      render action: "edit" 
    end
    @menu = "set"
  end
  
end
