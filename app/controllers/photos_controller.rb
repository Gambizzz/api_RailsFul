class PhotosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_photo, only: [:update, :destroy]

  # GET /photos
  def index
    @photos = current_user.photos
    render json: @photos
  end

  # POST /photos
  def create
    @photo = current_user.photos.build(photo_params)

    if @photo.save
      render json: @photo, status: :created
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /photos/:id
  def update
    if @photo.update(photo_params)
      render json: @photo
    else
      render json: @photo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /photos/:id
  def destroy
    @photo.destroy
    head :no_content
  end

  private

  def set_photo
    @photo = current_user.photos.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image)
  end
end

