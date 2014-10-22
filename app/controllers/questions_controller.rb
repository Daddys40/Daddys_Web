class QuestionsController < ApplicationController
	layout false

	class QuestionSheet
		SHEET = Roo::Excelx.new("config/keys/questions.xlsx")

		def self.question(week, count) 
			return nil if week < 5 
			SHEET.cell(1 + ((week - 5) * 3 + count), 2)
		end

		def self.normal_data(gender, week, count) 
			return nil if week < 5 
			if gender == 'male'
				{
					title: SHEET.cell(1 + ((week - 5) * 3 + count), 11), 
					content: SHEET.cell(1 + ((week - 5) * 3 + count), 12) 
				}
			else 
				{
					title: SHEET.cell(1 + ((week - 5) * 3 + count), 10), 
					content: SHEET.cell(1 + ((week - 5) * 3 + count), 12)
				}
			end
		end 

		def self.anwser_text(answer, gender, week, count) 
			return nil if week < 5 
			if answer 
				if gender == 'male'
					a = SHEET.cell(1 + ((week - 5) * 3 + count), 3) 
					b = SHEET.cell(1 + ((week - 5) * 3 + count), 7) 
					{
						title: a,
						content: b
					}
				else 
					{
						title: "검사 결과입니다",
						content: SHEET.cell(1 + ((week - 5) * 3 + count), 5) 
					}
				end
			else
				if gender == 'male'
					a = SHEET.cell(1 + ((week - 5) * 3 + count), 4) 
					b = SHEET.cell(1 + ((week - 5) * 3 + count), 8) 
					{
						title: a,
						content: b
					}
				else 
					{
						title: "검사 결과입니다",
						content: SHEET.cell(1 + ((week - 5) * 3 + count), 5) 
					}
				end
			end
 		end
 	end

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

	def no_question

	end
end
