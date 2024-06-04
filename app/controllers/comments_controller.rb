class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:update, :destroy]

  # GET /articles/:article_id/comments
  def index
    @comments = @article.comments
    render json: @comments
  end

  # POST /articles/:article_id/comments
  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/:article_id/comments/:id
  def update
    if @comment.user == current_user
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: @comment.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You can only edit your own comments' }, status: :forbidden
    end
  end

  # DELETE /articles/:article_id/comments/:id
  def destroy
    if @comment.user == current_user
      @comment.destroy
      head :no_content
    else
      render json: { error: 'You can only delete your own comments' }, status: :forbidden
    end
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def set_comment
    @comment = @article.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end

