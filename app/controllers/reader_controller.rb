class ReaderController < ApplicationController
  def show
    @posts = Kaminari.paginate_array(FetchPostsService.perform).page(params[:page]).per(20)
  end
end
