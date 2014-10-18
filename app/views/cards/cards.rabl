object @cards

node(:data) { |cards| 
	partial("cards/card", :object => cards) 
}