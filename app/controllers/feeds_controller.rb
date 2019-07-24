# frozen_string_literal: true

class FeedsController < ApplicationController
  before_action :set_feed, only: %i[edit update destroy]

  respond_to :html

  def index
    @feeds = Feed.default_order.page(params[:page]).per(20)
  end

  def new
    @feed_form = FeedForm.new
  end

  def create
    @feed_form = FeedForm.new

    if @feed_form.perform(feed_params)
      redirect_to feeds_path, notice: 'Feed created'
    else
      flash.now[:alert] = 'Url should lead to an RSS feed'
      render :new
    end
  end

  def edit
    @feed_form = FeedForm.new(@feed)
  end

  def update
    @feed_form = FeedForm.new(@feed)

    if @feed_form.perform(feed_params)
      redirect_to feeds_path, notice: 'Feed updated'
    else
      render :edit, alert: @feed.errors.messages.first
    end
  end

  def destroy
    if @feed.destroy
      redirect_to feeds_path, notice: 'Feed deleted'
    else
      redirect_to feeds_path, alert: 'Could not delete Feed'
    end
  end

  private

  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:url)
  end
end
