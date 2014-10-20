object @card

attributes :id
attributes :title
node(:created_at) { |u| u.created_at.to_s }
node(:updated_at) { |u| u.created_at.to_s }
attributes :week
attributes :readed
attributes :content
node(:resources) { return [] }

# id: 1,
# title: "Some Title", 
# week: 15,
# readed: false,
# content: "asldjghsajlgsdghjsdlf lksdajfhdk fhsfljkshdl kfhlsadjkhsdjaklfhlsadkj fadhsjf sjfkl dskjfhsjkda fljksadfk lalfkhsaldjk fhsdafas df",
# resources: [
#   {
#     type: "image",
#     width: 320,
#     height: 200,
#     image_url: "http://cfile30.uf.tistory.com/image/21769F46533A841516123F"
#   }
# ]