class PapersController < ApplicationController
  before_action :authenticate_user!, except: [:create]
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
      choices=MultipleChoice.import multiple_choices
    end
    redirect_back(fallback_location: root_path)
  end

  def view_questions
    @paper=Paper.where(id:params[:paper_id]).try(:first)
  end

  def edit
    @paper=Paper.where(id:params[:id]).try(:first)
  end

  def update
    @paper=Paper.where(id:params[:paper_id]).try(:first)
    @paper.subject=params[:paper]['subject']
    @paper.save
    if params[:questions].present?
      questions=[]
      questionss=[]
      params[:questions].keys.each do |obj|
        @question=Question.where(id:params[:questions]["#{obj}"]['id']).try(:first)
        if @question.present?
          @question.name=params[:questions]["#{obj}"]['name']
          questions.push(@question)
        else
          @question=Question.new(new_question_params(params[:questions]["#{obj}"]))
          @question.paper_id=@paper.id
          questions.push(@question)
        end
        # params[:multiple_choices]["#{obj}"]['question_id']=@question.id
      end
      # BlockTransaction.import block_transactions, on_duplicate_key_update: {conflict_target: [:sequence_id], columns: [:updated_at, :tx_amount, :net_fee, :total_net, :privacy_fee, :fee_in_cents, :amount_in_cents]}
      if questions.present?
        questions=Question.import questions , on_duplicate_key_update: {conflict_target: [:id], columns: [:name]}
      end
    end
    if params[:multiple_choices].present? && questions.present?
      multiple_choices=[]
      params[:multiple_choices].keys.each do |obj|
        @multiple_choices=MultipleChoice.where(id:params[:multiple_choices]["#{obj}"]['id']).try(:first)
        if @multiple_choices.present?
          # @multiple_choices=MultipleChoice.new(new_multiple_params(params[:multiple_choices]["#{obj}"]))
          @multiple_choices.option_a=params[:multiple_choices]["#{obj}"]['option_a']
          @multiple_choices.option_b=params[:multiple_choices]["#{obj}"]['option_b']
          @multiple_choices.option_c=params[:multiple_choices]["#{obj}"]['option_c']
          @multiple_choices.option_d=params[:multiple_choices]["#{obj}"]['option_d']
          @multiple_choices.option_e=params[:multiple_choices]["#{obj}"]['option_e']
          @multiple_choices.correct_option=params[:multiple_choices]["#{obj}"]['correct_option']
          multiple_choices.push(@multiple_choices)
        else
          @multiple_choices=MultipleChoice.new(new_multiple_params(params[:multiple_choices]["#{obj}"]))
          @multiple_choices.question_id=questions.ids[obj.try(:to_i)]

          multiple_choices.push(@multiple_choices)
          # @multiple_choices.question_id=@paper.id
        end
        # @multiple_choices.save
      end
      # choices=MultipleChoice.import multiple_choices
      if multiple_choices.present?
        multiple_choices=MultipleChoice.import multiple_choices , on_duplicate_key_update: {conflict_target: [:id], columns: [:option_a,:option_b,:option_c,:option_d,:option_e,:correct_option]}
      end
    end
    flash[:success]='Paper is updated'
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
