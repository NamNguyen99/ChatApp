import consumer from "./consumer"

const chatGroupChannel = consumer.subscriptions.create("ChatGroupChannel", {
  connected() {
    console.log("Connected to the chat group!");
  },

  disconnected() {

  },

  received(data) {
    if (data.message) {
      let msg_class = data.message.user_id === +$('#user_id').text() ? "message-sent" : "message-received"
      let list_select = "#multi-messages-list" + "-" + data.message.target_id
      if(data.message.body) {
        $(list_select).append(`<p class='${msg_class}'>` + data.message.body + '</p>')
      }
      for (let i = 0; i < data.file.length; i++) {
        $(list_select).append(`<img src='${data.file[i]}' class='${msg_class}' width='300px'> `)
      }

      $(list_select).animate({ scrollTop: $(list_select).prop("scrollHeight")}, 1000);
    } else if(data.chat_room_name) {
      let name = data.chat_room_name;
      let announcement_type = data.type == 'join' ? 'joined' : 'left';
      // $(list_select).append(`<p class="announce"><em>${name}</em> ${announcement_type} the room</p>`)
    }
  },

  speak(message) {
    let name = sessionStorage.getItem('chat_room_name')
    this.perform('speak', { message, name })
  },

  announce(content) {
    this.perform('announce', { name: content.name, type: content.type })
  }
});

export default chatGroupChannel;
