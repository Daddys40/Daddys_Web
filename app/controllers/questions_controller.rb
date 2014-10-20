class QuestionsController < ApplicationController
	layout false

	class QuestionSheet
		SHEET = Roo::Excelx.new("config/keys/questions.xlsx")

		def self.question(week, count) 
			return nil if week < 5 
			SHEET.cell(1 + ((week - 5) * 3 + count), 2)
		end

		def self.yes_anwser(week, count) 
			return nil if week < 5 
			a = SHEET.cell(1 + ((week - 5) * 3 + count), 3) 
			b = SHEET.cell(1 + ((week - 5) * 3 + count), 8) 
			"#{a}\n##{b}"
		end

		def self.no_anwser(week, count) 
			return nil if week < 5 
			a = SHEET.cell(1 + ((week - 5) * 3 + count), 4) 
			b = SHEET.cell(1 + ((week - 5) * 3 + count), 6) 
			"#{a}\n#{b}"
		end
 	end

	def new
		@user = User.find_by_authentication_token(params[:authentication_token])
		@question = QuestionSheet.question(params[:week].to_i, params[:count].to_i)
	end
	
	def create
			
	end

	def no_question

	end
end
