class FieldsController < ApplicationController
  include FieldParams

  before_action :set_field, only: %i[show edit update destroy]

  def index
    @fields = Field.all
    @geojsons = @fields.map(&:shape_as_geojson)
  end

  def show
    @geojson = @field.shape_as_geojson
  end

  def new
    @field = Field.new
  end

  def edit
    @geojson = @field.shape_as_geojson
  end

  def create
    @field = Field.new(field_params)
    @field.shape = shape_attr
    return default_response(@field, :created, :show) if @field.save

    default_response(@field, :unprocessable_entity, :new)
  end

  def update    
    @field.name = field_params[:name]
    @field.shape = shape_attr
    return default_response(@field, :ok, :show) if @field.save

    default_response(@field, :unprocessable_entity, :edit)
  end

  def destroy
    @field.destroy!

    respond_to do |format|
      format.html { redirect_to fields_path, status: :see_other, notice: "Field was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_field
    @field = Field.find(params[:id])
  end
end
