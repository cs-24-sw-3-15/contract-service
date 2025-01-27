class LabelsController < ApplicationController
  before_action :authenticate_user!

  def index
    @labels = policy_scope(Label).order(:tag)
  end

  def show
    @label = authorize Label.find(params["id"])
  end

  def new
    @label = authorize Label.new
    @labels = policy_scope(Label).order(:tag).map { [ _1.stamp, _1.id ] }
  end

  def create
    @label = authorize Label.new(label_params)

    if @label.save
      redirect_to labels_path, notice: "Label successfully created."
    else
      render :new
    end
  end

  def destroy
    @label = authorize Label.find(params["id"])
    @label.destroy

    redirect_to labels_path, notice: "Label successfully destroyed."
  end

  def label_params
    params.require(:label).permit(:title, :parent_id, :identifier, :color)
  end
end
