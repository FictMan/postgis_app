class FieldsController < ApplicationController
  before_action :set_field, only: %i[show edit update destroy ]

  def index
    @fields = Field.all
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
    shape_geojson = params[:field][:shape]
    parsed_geojson = RGeo::GeoJSON.decode(shape_geojson, json_parser: :json)
    @field.shape = parsed_geojson

    respond_to do |format|
      if @field.save
        format.html { redirect_to @field, notice: "Field was successfully created." }
        format.json { render :show, status: :created, location: @field }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    shape_geojson = params[:field][:shape]
    parsed_geojson = RGeo::GeoJSON.decode(shape_geojson, json_parser: :json)
    @field.shape = parsed_geojson

    respond_to do |format|
      if @field.update(field_params)
        format.html { redirect_to @field, notice: "Field was successfully updated." }
        format.json { render :show, status: :ok, location: @field }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @field.errors, status: :unprocessable_entity }
      end
    end
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

    def field_params
      params.require(:field).permit(:name, :shape)
    end
end
