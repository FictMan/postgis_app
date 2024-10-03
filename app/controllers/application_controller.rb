# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def default_response(resource, status, template)
    respond_to do |format|
      if status == :created || status == :ok
        format.html { redirect_to resource, notice: "#{resource.class.name} was successfully #{status == :created ? 'created' : 'updated'}." }
        format.json { render template, status: status, location: resource }
      else
        format.html { render template, status: status }
        format.json { render json: resource.errors, status: status }
      end
    end
  end
end
