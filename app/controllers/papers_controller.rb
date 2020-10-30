class PapersController < ApplicationController

  def index

  end

  def new
    @paper=Paper.new
  end

  def index
    @papers=Paper.all.order('id DESC')
  end

  def questions
    @papers=Paper.all
  end

  def solve_paper
    @paper=Paper.where(id:params[:id]).try(:first)
  end

  def submit_paper
    params[:paper_id]=Paper.last.id
    user=User.where(id:params[:user_id]).try(:first)
    if params[:paper_id].present?
      paper=Paper.where(id:params[:paper_id]).try(:first)
      ids=paper.questions.pluck(:id)
      ids.each do |q|
        if params["question_#{q}"].present?
          question=Question.includes(:multiple_choice).where(id:q).try(:first)
          multiple_choice=question.multiple_choice
          # question=MultipleChoice.where(id:q).try(:first)
          if params["question_#{q}"]['answer'].present?
            user_answer=UserAnswer.new(user_id:user.id)
            user_answer.question_id=question.id
            user_answer.paper_id=paper.id
            user_answer.selected_option=params["question_#{q}"]['answer']
            if multiple_choice.correct_option==params["question_#{q}"]['answer']
              user_answer.is_correct=true
            end
            user_answer.save
          end
        end
        end
    end
    redirect_to root_path
  end
  def create
    @paper=Paper.new(new_paper_params)
    @paper.save
    if params[:questions].present?
      questions=[]
      params[:questions].keys.each do |obj|
        @question=Question.new(new_question_params(params[:questions]["#{obj}"]))
        @question.paper_id=@paper.id
        # params[:multiple_choices]["#{obj}"]['question_id']=@question.id
        questions.push(@question)
      end
      questions=Question.import questions
    end
    if params[:multiple_choices].present? && questions.present?
      multiple_choices=[]
      params[:multiple_choices].keys.each do |obj|
        @multiple_choices=MultipleChoice.new(new_multiple_params(params[:multiple_choices]["#{obj}"]))
        @multiple_choices.question_id=questions.ids[obj.try(:to_i)]
        # @multiple_choices.paper_id=params[:questions]["#{obj}"].id
        # @multiple_choices.save
        multiple_choices.push(@multiple_choices)
      end
      # choices=MultipleChoice.import multiple_choices
    end
    redirect_back(fallback_location: root_path)
  end

  private
  def new_paper_params
    params.require(:paper).permit(:subject)
  end
  def new_question_params(obj)
    obj.permit(:name,:paper_id)
  end

  def new_multiple_params(obj)
    # params.require(:multiple_choices).permit(:question_id,:option_a,:option_b,:option_c,:option_d,:option_e,:correct_option)
    obj.permit(:question_id,:option_a,:option_b,:option_c,:option_d,:option_e,:correct_option)
  end
end
