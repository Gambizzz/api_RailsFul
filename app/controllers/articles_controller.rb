class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_article, only: [:show, :update, :destroy]
  before_action :check_author, only: [:update, :destroy]

  # GET /articles
  def index
    @articles = Article.where(private: false)
    render json: @articles
  end

  # GET /articles/290
  def show
    @article = Article.find(params[:id])
    if @article.private && @article.user != current_user
      render json: { error: "Not authorized" }, status: :forbidden
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/290
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/290
  def destroy
    @article.destroy
  end

  private
    def set_article
      @article = Article.find(params[:id])
    end

    def check_author
      unless current_user == @article.user
        redirect_to root_path
      end
    end

    def article_params
      params.require(:article).permit(:title, :content, :user_id, :private)
    end
end

