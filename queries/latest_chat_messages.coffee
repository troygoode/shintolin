db = require '../db'

module.exports = (character, cb) ->
  test_message =
    sender_name: 'IcePie'
    sender_id: 1234
    sent: new Date(2010, 3, 2)
    type: 'fed'
    food: 'a hunk of cooked meat'
  test_message2 =
    sender_name: 'Miejoe'
    sender_id: 5678
    sent: new Date(2013, 0, 14)
    type: 'social'
    text: 'yes, that\'s exactly what I meant. O hai Berksey! Yes, mebbe I should start playing LR again.'
  cb null, [test_message, test_message2]
