class StudentsController < ApplicationController
  layout 'application'

  def new
    @user=User.new
  end

  def index
    @users=User.student
  end
  def update
    @user=User.where(id:params[:id]).try(:first)
    if @user.present? && @user.is_block?
      @user.update(is_block:false)
      flash[:sucess]='User Blocked succesfully'
    else
      @user.update(is_block:true) if @user.present?
      flash[:sucess]='User is Un-Blocked'
    end
    redirect_back(fallback_location: root_path)
  end
  def create
    @user=User.new(new_student_params)
    @user.role='student'
    if @user.save
      flash[:sucess]='User Saved succesfully'
    else
      flash[:sucess]='User not saved succesfully'
    end
    redirect_to students_url
  end

  def student_paper
    if params[:id].present?
      count= UserAnswer.where(user_id:params[:id]).pluck(:paper_id).try(:uniq)
      @papers=Paper.where(id:count)
    end
  end

  def view_paper
    @paper=Paper.where(id:params[:paper_id]).try(:first)
  end

  private
  def new_student_params
    params.require(:user).permit(:email,:password)
  end
end
