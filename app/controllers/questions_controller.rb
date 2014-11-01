class QuestionsController < ApplicationController
	layout false

	def new
		@user = User.find_by_authentication_token(params[:authentication_token])
		@question = QuestionSheet.question(params[:week].to_i, params[:count].to_i)
	end
	
	def create
		@user = User.find_by_authentication_token(params[:authentication_token])
		@answer = params[:answer].to_i != 0

		my_anwser_text = QuestionSheet.anwser_text(@answer, "female", params[:week].to_i, params[:count].to_i)
		@user.cards.create(title: my_anwser_text[:title], content: my_anwser_text[:content], week: params[:week].to_i, resources_count: 0)

		if @user.partner
			partner_anwser_text = QuestionSheet.anwser_text(@answer, "male", params[:week].to_i, params[:count].to_i)
			@user.partner.cards.create(title: partner_anwser_text[:title], content: partner_anwser_text[:content], week: params[:week].to_i, resources_count: 0)
		end
	end
end
