class QuestionsController < ApplicationController
	layout false

	class QuestionSheet
		SHEET = Roo::Excelx.new("config/keys/questions.xlsx")

		def self.question(week, count) 
			return nil if week < 5 
			SHEET.cell(1 + ((week - 5) * 3 + count), 2)
		end
	end


	def new
		
	end
	
	def create
	
	end

	def no_question

	end

end
