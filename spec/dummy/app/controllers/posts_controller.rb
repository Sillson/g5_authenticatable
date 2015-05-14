class PostsController < ApplicationController
  before_action :authenticate_api_user!, unless: :is_navigational_format?
  before_action :authenticate_user!, if: :is_navigational_format?

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  respond_to :json, except: [:new, :edit]
  respond_to :html

  # GET /posts
  def index
    authorize(Post)
    @posts = Post.all
    respond_with(@posts)
  end

  # GET /posts/1
  def show
    authorize(@post)
    respond_with(@post)
  end

  # GET /posts/new
  def new
    @post = Post.new
    authorize(@post)
    respond_with(@post)
  end

  # GET /posts/1/edit
  def edit
    authorize(@post)
    respond_with(@post)
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    authorize(@post)
    if @post.save
      flash[:notice] = 'Post was successfully created.'
    end
    respond_with(@post)
  end

  # PATCH/PUT /posts/1
  def update
    authorize(@post)
    if @post.update(post_params)
      flash[:notice] = 'Post was successfully updated.'
    end
    respond_with(@post)
  end

  # DELETE /posts/1
  def destroy
    authorize(@post)
    if @post.destroy
      flash[:notice] = 'Post was successfully destroyed.'
    end
    respond_with(@post)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:content, :author_id)
    end
end
