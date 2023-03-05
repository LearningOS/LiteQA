class PostsController < ApplicationController
  layout -> { 'application' }
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :set_posts, only: %i[ index show new edit ]

  # GET /posts or /posts.json
  def index
  end

  def cid_redirect
    @post = Post.find_by(cid: params[:cid])
    redirect_to @post
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_posts
    if params[:folders]
      @pinned_posts = []
      @posts = Post.tagged_with(params[:folders]).distinct
    else
      @pinned_posts = Post.pinned unless params[:page]
      @pagy, @posts = pagy(Post.unpinned, items: 100)
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.with_rich_text_rich_content_and_embeds.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content, :rich_content)
  end
end
