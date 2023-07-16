import { LightningElement, track, api, wire } from 'lwc';

import generateResponse from '@salesforce/apex/ChatGPTService.generateResponse';

import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import UserNameFIELD from '@salesforce/schema/User.Name';
import userEmailFIELD from '@salesforce/schema/User.Email';
import userIsActiveFIELD from '@salesforce/schema/User.IsActive';
import userAliasFIELD from '@salesforce/schema/User.Alias';

export default class ChatGPTBot extends LightningElement {
    @track conversation = [];
    @track messageInput = '';
    @track waitingChatGPT = false;

    @track error;
    @track userId = Id;
    @track currentUserName;
    @track currentUserEmail;
    @track currentIsActive;
    @track currentUserAlias;

    @wire(getRecord, { recordId: Id, fields: [UserNameFIELD, userEmailFIELD, userIsActiveFIELD, userAliasFIELD ]}) 
    currentUserInfo({error, data}) {
        if (data) {
            this.currentUserName = data.fields.Name.value;
            this.currentUserEmail = data.fields.Email.value;
            this.currentIsActive = data.fields.IsActive.value;
            this.currentUserAlias = data.fields.Alias.value;
        } else if (error) {
            this.error = error ;
        }
    }

    handleChange(event) {
        if (event && event.target) {
            this.messageInput = event.target.value;
        }
    }

    async handleSendMessage() {
        this.displayTypingOutput();

        if (this.messageInput && this.messageInput.trim() !== '') {
            const userMessage = {
                id: 'user-' + this.conversation.length,
                role: 'user',
                text: this.messageInput,
                containerClass: 'slds-chat-message slds-chat-message_outbound user-message',
                textClass: 'slds-chat-message__text slds-chat-message__text_outbound',
                isBot : false
            };
            this.conversation = [...this.conversation, userMessage];
            this.messageInput = '';
            this.waitingChatGPT = true;

            try {
                const chatGPTResponse = await generateResponse({ messageText: this.conversation[this.conversation.length - 1]?.text });
                if (chatGPTResponse && chatGPTResponse.trim() !== '') {
                    const assistantMessage = {
                        id: 'assistant-' + this.conversation.length,
                        role: 'assistant',
                        text: chatGPTResponse,
                        containerClass: 'slds-chat-message slds-chat-message_inbound',
                        textClass: 'slds-chat-message__text slds-chat-message__text_inbound',
                        isBot : true
                    };
                    this.conversation = [...this.conversation, assistantMessage];

                    this.waitingChatGPT = false;
                } else {
                    console.error('Error generating ChatGPT response: Empty response');
                }
            } catch (error) {
                console.error('Error generating ChatGPT response:', error);
            }
        }
    }

    @api
    async generateChatGPTResponse(prompt) {
        try {
            const response = await generateResponse({ prompt: prompt });
            return response;
        } catch (error) {
            console.error('Error: Unable to generate response from ChatGPT.', error);
            return 'Error: Unable to generate response from ChatGPT.';
        }
    }

    displayTypingOutput() {
        const welcomeMsg = 'Looking for the answer...';
        const typingOutput = welcomeMsg;
        const typingSpeed = 200; // The speed of typing, in milliseconds
        var chars = typingOutput.split('');
    
        let i = 0;
        const timer = setInterval(() => {
            if(i < chars.length) {
                const currentText = this.template.querySelector('.typing-output').textContent;
                this.template.querySelector('.typing-output').textContent = currentText + chars[i++];
            }else {
                i = 0;
                this.template.querySelector('.typing-output').textContent = '';
            }

        }, typingSpeed);
    }
    
}