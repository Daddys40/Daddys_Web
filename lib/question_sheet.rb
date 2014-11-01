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