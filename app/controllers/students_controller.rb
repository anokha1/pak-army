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
    if @user.present?
      @user.update(is_block:true)
      flash[:sucess]='User Updated succesfully'
    else
      flash[:sucess]='User not updated'

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

  private
  def new_student_params
    params.require(:user).permit(:email,:password)
  end
end
