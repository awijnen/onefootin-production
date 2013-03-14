class CompaniesController < ApplicationController
  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def companies_with_jobs
    @companies = Company.all

    respond_to do |format|
      format.html # companies_with_jobs.html.erb
    end
  end

  def company_connections
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # companies_with_jobs.html.erb
    end
  end


end
