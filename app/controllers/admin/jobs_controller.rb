class Admin::JobsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_filter :require_is_super_admin, only: [:new, :edit, ]

  layout "admin"

  def index
    @jobs = Job.all.recent.paginate(:page => params[:page], :per_page => 15)
  end

  def new
    @job = Job.new
  end

  def show
    @job = Job.find(params[:id])
    if @job.is_hidden
      redirect_to admin_account_jobs_path, alert: "概念已隐藏，无法查阅，你想清楚就好！"
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user

    if @job.save
      redirect_to admin_account_jobs_path
    else
      render :new
    end
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to admin_account_jobs_path, notice: "概念更新成功！这年头必须随时更新自己脑子里面的概念！"
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    redirect_to admin_account_jobs_path, alert: "概念已删除，如果后悔赶紧做个提取练习试试！快去，我等你！"
  end

  def publish
    @job = Job.find(params[:id])
    @job.publish!

    redirect_to :back
  end

  def hide
    @job = Job.find(params[:id])
    @job.hide!

    redirect_to :back
  end

  private

  def job_params
    params.require(:job).permit(:title, :description, :company_name, :wage_upper_bound, :wage_lower_bound, :contact_email, :category_name)
  end
end
