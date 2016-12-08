class CommentsController < ApplicationController
  include CommentSupport
  before_action :authenticate_user!

  def create
    comment = Comment.new(comment_params)
    if comment.save!
      send_email(comment)
      flash[:notice] = "Successfully created comment"
    else
      flash[:notice] = "Unsuccessfully attempted to create a comment."
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:author, :text, :user_id, :job_id, :ticket_id)
  end
end
