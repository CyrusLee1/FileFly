import { api } from './api.js';

const sendBtn = document.getElementById("sendMessage");
const inputContent = document.getElementById("input-content");
const content = document.getElementById("content");

// 创建聊天对话气泡
function addArrowbox() {
    const input = inputContent.value;
    if (input == "") return;

    const arrowbox = document.createElement('div');
    const p = document.createElement('p');
    p.textContent = input;

    arrowbox.className = "arrowbox";
    
    arrowbox.append(p);
    content.insertBefore(arrowbox, content.firstChild);
    inputContent.value = "";
}

// 监听回车键
inputContent.addEventListener("keydown", (event) => {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault();
      addArrowbox();
    }
});

// 绑定发送事件
sendBtn.onclick = addArrowbox;

//加载历史数据
(async function(){
    const messages = await api.getMessages();
    console.log(messages);
})();