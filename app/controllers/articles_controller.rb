class ArticlesController < ApplicationController

  http_basic_authenticate_with name: "jatin", password: "hariani", except: [:index, :show]

  def new
  end

  def index
    @articles = Article.all
  end


  def create
    @article = Article.new(article_params)

    @article.save
    redirect_to @article
  end

  def show
    @article = Article.find(params[:id])
  end

  def destroy
    render plain: "let go of your earthly tether."
  end

  private

  def article_params
    params.require(:article).permit(:title, :text)
  end

end
